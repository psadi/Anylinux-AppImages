## **Anylinux AppImages**

![Downloads](https://img.shields.io/endpoint?url=https://cdn.jsdelivr.net/gh/pkgforge-dev/Anylinux-AppImages@main/.github/badge.json)

Designed to run seamlessly on any Linux distribution, including older distributions and musl-based ones. Our AppImages bundle all the needed dependencies and do not depend on host libraries to work, unlike most other AppImages.

Most of the AppImages are made with [sharun](https://github.com/VHSgunzo/sharun). We also use an alternative, better [runtime](https://github.com/VHSgunzo/uruntime).

The uruntime [automatically falls back to using extract and run](https://github.com/VHSgunzo/uruntime?tab=readme-ov-file#built-in-configuration) if FUSE is not available at all, so we **truly have 0 requirements.**

We also try to avoid the usage of containers and other methods; so far, the only AppImage that depends on them is Lutris.

**How is this possible?** See: [How to guide](https://github.com/pkgforge-dev/Anylinux-AppImages/blob/main/HOW-TO-MAKE-THESE.md)

---

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Application List</title>
  <style>
    /* Use a CSS counter to generate the serial numbers automatically */
    table {
      border-collapse: collapse;
      width: 100%;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 8px;
    }
    th {
      background-color: #f2f2f2;
      text-align: left;
    }
    tbody {
      counter-reset: row-num;               /* start the counter */
    }
    tbody tr {
      counter-increment: row-num;           /* increment for each row */
    }
    tbody tr td:first-child::before {
      content: counter(row-num);            /* display the counter */
    }
  </style>
</head>
<body>

<table>
  <thead>
    <tr>
      <th>S.No</th>
      <th>Application</th>
    </tr>
  </thead>
  <tbody>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/alacritty-AppImage">alacritty</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/android-tools-AppImage">Android Tools</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/AppImageUpdate-Enhanced-Edition">AppImageUpdate</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/ares-emu-appimage">ares-emu</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Azahar-AppImage-Enhanced">Azahar</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Citron-AppImage">Citron</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Clementine-AppImage">Clementine</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Cromite-AppImage">Cromite</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/DeaDBeeF-AppImage">DeaDBeeF</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/DeSmuME-AppImage">DeSmuME</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Dolphin-emu-AppImage">Dolphin-emu</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/dunst-AppImage">dunst</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/EasyTAG-AppImage">EasyTAG</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/ghostty-appimage">Ghostty</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/GIMP-and-PhotoGIMP-AppImage">GIMP‑and‑PhotoGIMP</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Gnome-Calculator-AppImage">Gnome Calculator</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/gnome-pomodoro-appimage">Gnome Pomodoro</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Gnome-Text-Editor-AppImage">Gnome Text Editor</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/gpu-screen-recorder-AppImage">gpu-screen-recorder</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/htop-AppImage">htop</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/kdeconnect-AppImage">kdeconnect</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/ladybird-appimage">Ladybird</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Lutris-AppImage">Lutris</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/MAME-AppImage">MAME</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/mednafen-appimage">Mednafen</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/mpv-AppImage">mpv</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/NSZ-AppImage">NSZ</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/OBS-Studio-AppImage">OBS Studio</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/pavucontrol-qt-AppImage">pavucontrol-qt</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Pixelpulse2-AppImage">Pixelpulse2</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/playerctl-AppImage">playerctl</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/polybar-AppImage">polybar</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/puddletag-AppImage">puddletag</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Rnote-AppImage">Rnote</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/rofi-AppImage">rofi</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/scrcpy-AppImage">scrcpy</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/SpeedCrunch-AppImage">SpeedCrunch</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/st-AppImage">st</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/strawberry-AppImage">strawberry</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Sudachi-AppImage">Sudachi</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Torzu-AppImage">Torzu</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/transmission-qt-AppImage">transmission-qt</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/UnleashedRecomp-AppImage">UnleashedRecomp</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/xenia-canary-AppImage">xenia-canary</a></td></tr>
    <tr><td></td><td><a href="https://github.com/pkgforge-dev/Zenity-GTK3-AppImage">Zenity</a></td></tr>
  </tbody>
</table>

</body>
</html>

---

Also see [other projects](https://github.com/VHSgunzo/sharun?tab=readme-ov-file#projects-that-use-sharun) that use sharun for more. **Didn't find what you were looking for?** Open an issue here and we will see what we can do.
