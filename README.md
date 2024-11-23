**Anylinux AppImages**

Designed to run seamlessly on any Linux distribution, that includes old distrubiton and musl based ones. Our AppImages bundle all the needed dependencies and do not depend on host libraries to work unlike most other AppImages.

Most of the AppImages are made with[sharun](https://github.com/VHSgunzo/sharun). and some also use an alternative better [runtime](https://github.com/VHSgunzo/uruntime).

The only dependency we have is a `fusermount` binary in `PATH`, but even this isn't extrictly needed as these AppImages can still work by setting the `APPIMAGE_EXTRACT_AND_RUN=1` env variable. 

We also try to avoid the usage of containers and other methods that depend on user namespaces and so far none of the AppImages need it in order to work.

---------------------------------------------------------------------------------------------

[Android Tools](https://github.com/pkgforge-dev/android-tools-AppImage)

[DeaDBeeF](https://github.com/pkgforge-dev/DeaDBeeF-AppImage)

[mpv](https://github.com/pkgforge-dev/mpv-AppImage)

[OBS Studio](https://github.com/pkgforge-dev/OBS-Studio-AppImage)

[PPSSPP](https://github.com/pkgforge-dev/PPSSPP-AppImage)

[puddletag](https://github.com/pkgforge-dev/puddletag-AppImage)

[rofi](https://github.com/pkgforge-dev/rofi-AppImage)

[strawberry](https://github.com/pkgforge-dev/strawberry-AppImage)










