# Ambient noise applet for Plasma 5
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
+ Commit and open a [pull
request on
GitHub](https://github.com/m-pilia/plasma-applet-ambientnoise/pulls).

# License
The project is licensed under GPL 3. See [LICENSE](./LICENSE)
file for the full license.
