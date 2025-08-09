#!/bin/sh

# wrapper script for sharun that simplifies deployment to simple one liners
# Will try to detect and force deployment of GTK, QT, OpenGL, etc
# You can also force their deployment by setting the respective env variables
# for example set DEPLOY_OPENGL=1 to force opengl to be deployed

set -e

ARCH="$(uname -m)"

SHARUN_LINK="${SHARUN_LINK:-https://github.com/VHSgunzo/sharun/releases/latest/download/sharun-$ARCH-aio}"
DEFAULT_FLAGS=1

DEPLOY_QT=${DEPLOY_QT:-0}
DEPLOY_GTK=${DEPLOY_GTK:-0}
DEPLOY_OPENGL=${DEPLOY_OPENGL:-0}
DEPLOY_VULKAN=${DEPLOY_VULKAN:-0}
DEPLOY_PIPEWIRE=${DEPLOY_PIPEWIRE:-0}

_echo() {
	printf '\033[1;92m%s\033[0m\n' "$*"
}

case "$1" in
	''|--help)
		>&2 echo "USAGE: ${0##*/} /path/to/binaries_and_libraries"
		>&2 echo
		>&2 echo "You can also pass flags for sharun, example:"
		>&2 echo "${0##*/} l -p -v -s /path/to/bins_and_libs"
		>&2 echo
		>&2 echo "You can also force bundling with vars, example:"
		>&2 echo "DEPLOY_OPENGL=1 ${0##*/} /path/to/bins"
		>&2 echo
		>&2 echo "If first argument is not a flag we will default to:"
		>&2 echo "--dst-dir ./AppDir"
		>&2 echo "--verbose"
		>&2 echo "--with-hooks"
		>&2 echo "--strace-mode"
		>&2 echo "--gen-lib-path"
		>&2 echo "--hard-links"
		>&2 echo "--strip"
		exit 1
		;;
	-*)
		echo "Using user provided flags instead of defaults"
		DEFAULT_FLAGS=0
		;;
esac

if [ -z "$LIB_DIR" ]; then
	if [ -d "/usr/lib/$ARCH-linux-gnu" ]; then
		LIB_DIR="/usr/lib/$ARCH-linux-gnu"
	elif [ -d "/usr/lib" ]; then
		LIB_DIR="/usr/lib"
	else
		>&2 echo "ERROR: there is no /usr/lib directory in this system"
		>&2 echo "set the LIB_DIR variable to where you have libraries"
		exit 1
	fi
fi

if [ ! -x /tmp/sharun-aio ]; then
	_echo "Downloading sharun..."
	if command -v wget 1>/dev/null; then
		wget -q "$SHARUN_LINK" -O /tmp/sharun-aio  || exit 1
	elif command -v curl 1>/dev/null; then
		curl -Ls "$SHARUN_LINK" -o /tmp/sharun-aio || exit 1
	else
		>&2 echo "ERROR: we need wget or curl to download sharun"
		exit 1
	fi
	chmod +x /tmp/sharun-aio
fi

for bin do
	# ignore flags
	case "$bin" in -*) continue;; esac

	# check linked libraries and enable each mode accordingly
	for lib in $(ldd "$bin" | awk '{print $1}'); do
		case "$lib" in
			*libQt5Core.so*)     DEPLOY_QT=1;  QT_DIR=qt5     ;;
			*libQt6Core.so*)     DEPLOY_QT=1;  QT_DIR=qt6     ;;
			*libgtk-3*.so*)      DEPLOY_GTK=1; GTK_DIR=gtk-3.0;;
			*libgtk-4*.so*)      DEPLOY_GTK=1; GTK_DIR=gtk-4.0;;
			*libgdk_pixbuf*.so*) DEPLOY_GDK=1                 ;;
			*libpipewire*.so*)   DEPLOY_PIPEWIRE=1            ;;
		esac
	done
done

if [ "$DEPLOY_QT" = 1 ] && [ -z "$QT_DIR" ]; then
	>&2 echo
	>&2 echo "WARNING: Qt deployment was forced but we do not know what"
	>&2 echo "version of Qt needs to be deployed!"
	>&2 echo "We will default to Qt6, if you do not want that set the"
	>&2 echo "QT_DIR variable to the name of the Qt dir in $LIB_DIR"
	>&2 echo
	QT_DIR=qt6
fi

if [ "$DEPLOY_GTK" = 1 ] && [ -z "$GTK_DIR" ]; then
	>&2 echo
	>&2 echo "WARNING: GTK deployment was forced but we do not know what"
	>&2 echo "version of GTK needs to be deployed!"
	>&2 echo "We will default to gtk-3.0, if you do not want that set the"
	>&2 echo "GTK_DIR variable to the name of the gtk dir in $LIB_DIR"
	>&2 echo
	GTK_DIR=gtk-3.0
fi

_echo "------------------------------------------------------------"
_echo "Starting deployment, checking if extra libraries need to be added..."
echo ""

# always deploy minimal amount of gconv
if [ -d "$LIB_DIR"/gconv ]; then
	_echo "* Deploying minimal gconv"
	set -- "$@" \
		"$LIB_DIR"/gconv/UTF*.so*   \
		"$LIB_DIR"/gconv/ANSI*.so*  \
		"$LIB_DIR"/gconv/CP*.so*    \
		"$LIB_DIR"/gconv/LATIN*.so* \
		"$LIB_DIR"/gconv/UNICODE*.so*
fi

if [ "$DEPLOY_QT" = 1 ]; then
	# some distros have a qt dir rather than qt6 or qt5 dir
	if [ ! -d "$LIB_DIR"/"$QT_DIR" ]; then
		QT_DIR=qt
	fi

	_echo "* Deploying $QT_DIR"
	set -- "$@" \
		"$LIB_DIR"/"$QT_DIR"/plugins/imageformats/*.so*  \
		"$LIB_DIR"/"$QT_DIR"/plugins/iconengines/*.so*   \
		"$LIB_DIR"/"$QT_DIR"/plugins/platform*/*.so*     \
		"$LIB_DIR"/"$QT_DIR"/plugins/styles/*.so*        \
		"$LIB_DIR"/"$QT_DIR"/plugins/wayland-*/*.so*     \
		"$LIB_DIR"/"$QT_DIR"/plugins/xcbglintegrations/*.so*
fi

if [ "$DEPLOY_GTK" = 1 ]; then
	_echo "* Deploying $GTK_DIR"
	DEPLOY_GDK=1
	if [ "$GTK_DIR" = "gtk-4.0" ]; then
		DEPLOY_OPENGL=1
	fi
	set -- "$@" \
		"$LIB_DIR"/"$GTK_DIR"/*/immodules/*  \
		"$LIB_DIR"/gio/modules/libdconfsettings.so
fi

if [ "$DEPLOY_GDK" = 1 ]; then
	_echo "* Deploying gdk-pixbuf"
	set -- "$@" \
		"$LIB_DIR"/gdk-pixbuf-*/*/loaders/*

fi

if [ "$DEPLOY_OPENGL" = 1 ] || [ "$DEPLOY_VULKAN" = 1 ]; then
	set -- "$@" \
		"$LIB_DIR"/dri/*   \
		"$LIB_DIR"/vdpau/* \
		"$LIB_DIR"/libgallium*.so*

	if [ "$DEPLOY_OPENGL" = 1 ]; then
		_echo "* Deploying OpenGL"
		set -- "$@" \
			"$LIB_DIR"/libEGL*.so*  \
			"$LIB_DIR"/libGLX*.so*  \
			"$LIB_DIR"/libOpenGL.so*
	fi

	if [ "$DEPLOY_VULKAN" = 1 ]; then
		_echo "* Deploying vulkan"
		set -- "$@" \
			"$LIB_DIR"/libvulkan*.so*  \
			"$LIB_DIR"/libVkLayer*.so*
	fi
fi

if [ "$DEPLOY_PIPEWIRE" = 1 ]; then
	_echo "* Deploying pipewire"
	set -- "$@" \
		"$LIB_DIR"/pipewire-*/* \
		"$LIB_DIR"/spa-*/*      \
		"$LIB_DIR"/spa-*/*/*    \
		"$LIB_DIR"/alsa-lib/*
fi


if command -v xvfb-run 1>/dev/null; then
	XVFB_CMD="xvfb-run -a --"
else
	>&2 echo "WARNING: xvfb-run was not detected on the system"
	>&2 echo "xvfb-run is used with sharun for strace mode, this is needed"
	>&2 echo "to find dlopened libraries as normally this script is going"
	>&2 echo "to be run in a headless enviromment where the application"
	>&2 echo "will fail to start and result strace mode will not be able"
	>&2 echo "to find the libraries dlopened by the application"
	XVFB_CMD=""
	sleep 3
fi

echo ""
_echo "Now jumping to sharun..."
_echo "------------------------------------------------------------"

if [ "$DEFAULT_FLAGS" = 1 ]; then
	mkdir -p ./AppDir
	$XVFB_CMD \
		/tmp/sharun-aio l  \
		--dst-dir ./AppDir \
		--verbose          \
		--with-hooks       \
		--strace-mode      \
		--gen-lib-path     \
		--hard-links       \
		--strip            \
		"$@"
else
	$XVFB_CMD /tmp/sharun-aio l "$@"
fi

echo ""
_echo "------------------------------------------------------------"
_echo "Finished deployment!"
_echo "------------------------------------------------------------"
