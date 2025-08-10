#!/bin/sh

# quickly turns an AppDir to a DWARFS AppImage with uruntime
# It will download both the uruntime and mkdwarfs
# The only dependency is zsyncmake

# By default it will assume that the AppDir is in the $PWD
# And will output the AppImage there as well

set -e

ARCH=${ARCH:-$(uname -m)}
APPDIR=${APPDIR:-$PWD/AppDir}
OUTPATH=${OUTPATH:-$PWD}
DWARFS_COMP="${DWARFS_COMP:-zstd:level=22 -S26 -B6}"
URUNTIME_LINK=${URUNTIME_LINK:-https://github.com/VHSgunzo/uruntime/releases/download/v0.4.3/uruntime-appimage-dwarfs-lite-$ARCH}
DWARFS_LINK=${DWARFS_LINK:-https://github.com/mhx/dwarfs/releases/download/v0.12.4/dwarfs-universal-0.12.4-Linux-$ARCH}
TMPDIR=${TMPDIR:-/tmp}
DWARFS_CMD="${DWARFS_CMD:-$TMPDIR/mkdwarfs}"
RUNTIME="${RUNTIME:-$TMPDIR/uruntime}"

_echo() {
	printf '\033[1;92m%s\033[0m\n' "$*"
}

_download() {
	if command -v wget 1>/dev/null; then
		DOWNLOAD_CMD="wget -qO"
	elif command -v curl 1>/dev/null; then
		DOWNLOAD_CMD="curl -Lso"
	else
		>&2 echo "ERROR: we need wget or curl to download $1"
		exit 1
	fi
	$DOWNLOAD_CMD "$@"
}

_try_to_find_icon() {
	>&2 echo "No $APPDIR/.DirIcon found, trying to find it in $APPDIR"

	# try the first top level .png or .svg before searching
	if cp -v "$APPDIR"/*.png "$APPDIR"/.DirIcon 2>/dev/null \
	  || cp -v "$APPDIR"/*.svg "$APPDIR"/.DirIcon 2>/dev/null; then
		>&2 echo "Found icon and copied it to $APPDIR/.DirIcon"
		return 0
	fi

	# Now search depper
	icon_name=$(awk -F'=' '/^Icon=/{print $2; exit}' "$APPDIR"/*.desktop)
	icon=$(find "$APPDIR" -type f -name "$icon_name".png -print -quit)
	if [ -n "$icon" ] && cp -v "$icon" "$APPDIR"/.DirIcon; then
		>&2 echo "Found $icon and copied it to $APPDIR/.DirIcon"
	else
		return 1
	fi
}

if [ ! -f "$APPDIR"/*.desktop ]; then
	>&2 echo "ERROR: No top level .desktop file found in $APPDIR"
	>&2 echo "Note it cannot be more than .desktop file in that location"
	exit 1
elif [ ! -f "$APPDIR"/.DirIcon ] && ! _try_to_find_icon; then
	>&2 echo "ERROR: No top level .DirIcon file found in $APPDIR"
	exit 1
elif [ ! -w "$OUTPATH" ]; then
	>&2 echo "ERROR: No write access to $OUTPATH"
	exit 1
fi

if [ -z "$OUTNAME" ]; then
	if [ -z "$APPNAME" ]; then
		APPNAME=$(
		  awk -F'=' '/^Name=/ {gsub(/ /,"_",$2); print $2; exit}' \
		  "$APPDIR"/*.desktop
		)
	fi

	if [ -n "$VERSION" ]; then
		OUTNAME="$APPNAME"-"$VERSION"-"$ARCH".AppImage
	else
		OUTNAME="$APPNAME"-"$ARCH".AppImage
		>&2 echo "WARNING: VERSION is not set"
		>&2 echo "WARNING: set it to include it in $OUTNAME"
	fi
fi

if [ -z "$UPINFO" ]; then
	>&2 echo "No update information given, trying to guess it..."
	if [ -n "$GITHUB_REPOSITORY" ]; then
		UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
		>&2 echo
		>&2 echo "Guessed $UPINFO as the update information"
		>&2 echo "It may be wrong so please set the UPINFO instead"
		>&2 echo
	else
		>&2 echo
		>&2 echo "We were not able to guess the update information"
		>&2 echo "Please add it if you will distribute the AppImage"
		>&2 echo
	fi
fi

if ! command -v zsyncmake 1>/dev/null; then
	>&2 echo "ERROR: Missing dependency zsyncmake"
	exit 1
fi

if command -v mkdwarfs 1>/dev/null; then
	DWARFS_CMD="$(command -v mkdwarfs)"
elif [ ! -x "$TMPDIR"/mkdwarfs ]; then
	_echo "Downloading dwarfs binary from $DWARFS_LINK"
	_download "$DWARFS_CMD" "$DWARFS_LINK"
	chmod +x "$DWARFS_CMD"
fi

if [ ! -x "$RUNTIME" ]; then
	_echo "Downloading uruntime from $URUNTIME_LINK"
	_download "$RUNTIME" "$URUNTIME_LINK"
	chmod +x "$RUNTIME"
fi

if [ "$URUNTIME_PRELOAD" = 1 ]; then
	_echo "------------------------------------------------------------"
	_echo "Setting runtime to always keep the mount point..."
	_echo "------------------------------------------------------------"
	sed -i -e 's|URUNTIME_MOUNT=[0-9]|URUNTIME_MOUNT=0|' "$RUNTIME"
fi

if [ -n "$UPINFO" ]; then
	_echo "------------------------------------------------------------"
	_echo "Adding update information \"$UPINFO\" to runtime..."
	_echo "------------------------------------------------------------"
	"$RUNTIME" --appimage-addupdinfo "$UPINFO"
fi

_echo "------------------------------------------------------------"
_echo "Making AppImage..."
_echo "------------------------------------------------------------"

"$DWARFS_CMD" \
	--force               \
	--set-owner 0         \
	--set-group 0         \
	--no-history          \
	--no-create-timestamp \
	-C $DWARFS_COMP       \
	--header "$RUNTIME"   \
	--input  "$APPDIR"    \
	--output "$OUTPATH"/"$OUTNAME"

if [ -n "$UPINFO" ]; then
	_echo "------------------------------------------------------------"
	_echo "Making zsync file..."
	_echo "------------------------------------------------------------"
	zsyncmake -u "$OUTNAME" "$OUTPATH"/"$OUTNAME"

	# there is a nasty bug that zsync make places the .zsync file in PWD
	if [ ! -f "$OUTPATH"/"$OUTNAME".zsync ] && [ -f "$OUTNAME".zsync ]; then
		mv "$OUTNAME".zsync "$OUTPATH"/"$OUTNAME".zsync
	fi
fi

_echo "------------------------------------------------------------"
_echo "All done! AppImage at:$OUTPATH/$OUTNAME"
_echo "------------------------------------------------------------"
