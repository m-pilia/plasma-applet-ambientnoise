# Ambient noise applet for Plasma 5
[![Travis CI Build Status](https://travis-ci.org/m-pilia/plasma-applet-ambientnoise.svg?branch=master)](https://travis-ci.org/m-pilia/plasma-applet-ambientnoise)

![screenshot](https://user-images.githubusercontent.com/8300317/27260682-155864dc-5432-11e7-8afa-4327cac14e32.png)

This applet for the KDE Plasma desktop allows to reproduce ambient noise.
Multiple noise components can be combined, controlling their individual volume.
The applet reads noise files and their icons from a given, customisable folder.
The noise and the icon must be in the same folder and share the same name,
except for the file extension.

The plasmoid remembers its state across reboots, including play/pause status,
volume, and active noise components. To prevent it from playing sound at
start-up, even if it was still playing at the time of the last shutdown, go to
the plasmoid settings and tick "Paused at start-up".

Free noises in a ready-to-use format for this plasmoid can be found in the
[anoise project](http://anoise.tuxfamily.org/).

# Build and install

The applet can be installed locally with
```bash
kpackagetool5 -t Plasma/Applet --install plasmoid
```
or globally with
```bash
cmake . -DCMAKE_INSTALL_PREFIX=`kf5-config --prefix`
make
sudo make install
```

To see the plasmoid, you may need to restart plasmashell
```bash
kquitapp5 plasmashell
kstart5 plasmashell
```

# Contribute

Questions, bug reports, and feature requests are welcome. Feel free to open an
[issue on
GitHub](https://github.com/m-pilia/plasma-applet-ambientnoise/issues).

New translations are welcome. Translation files are located in the
[translations folder](translations). To add a new translation:
+ Copy the template
file `plasma_applet_org.kde.plasma.ambientnoise.pot` to
`plasma_applet_org.kde.plasma.ambientnoise_XX.po` (where `XX` is the [ISO 639-1
code](http://www.loc.gov/standards/iso639-2/php/English_list.php) for the
language you are adding).
+ Fill all the fields inside the file.
+ Add two lines to
  [`plasmoid/metadata.desktop`](https://github.com/m-pilia/plasma-applet-ambientnoise/blob/master/plasmoid/metadata.desktop)
  as follows, next to the corresponding pre-existing lines (once again, `XX`
  represents the ISO code of the new language):
    + `Name[XX]=...` filled with a translation of the name;
    + `Comment[XX]=...` filled with a translation of the comment.
+ Commit and open a [pull
request on
GitHub](https://github.com/m-pilia/plasma-applet-ambientnoise/pulls).

# Troubleshooting

In case something seems not to be working, launch the plasmoid in debug mode
from a console, with `plasmoidviewer -a org.kde.plasma.ambientnoise` or
`plasmawindowed org.kde.plasma.ambientnoise`, and look for relevant log
messages. Especially when it comes to audio playback, most of the troubles come
from bad configuration of the multimedia back-end, or missing plugins.

If no audio is played, or the audio plays but the volume controls do not work,
or if you see messages like `Error: "The autoaudiosink element is missing."` or
`Warning: "No volume control found"`, try installing
[gst-plugins-good](https://gstreamer.freedesktop.org/modules/gst-plugins-good.html).

# License
The project is licensed under GPL 3. See [LICENSE](./LICENSE)
file for the full license.
