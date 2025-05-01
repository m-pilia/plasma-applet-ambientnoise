# Ambient noise applet for Plasma 6
[![Checks](https://github.com/m-pilia/plasma-applet-ambientnoise/workflows/Checks/badge.svg)](https://github.com/m-pilia/plasma-applet-ambientnoise/actions/workflows/checks.yml)


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

# Build and install

The applet can be installed locally with
```bash
git clone https://github.com/m-pilia/plasma-applet-ambientnoise
cd plasma-applet-ambientnoise/
kpackagetool6 -t Plasma/Applet --install plasmoid
```
or globally with
```bash
git clone https://github.com/m-pilia/plasma-applet-ambientnoise
cd plasma-applet-ambientnoise/
mkdir build
cmake . -B build
cmake --build build
sudo cmake --install build
```

To see the plasmoid, you may need to restart plasmashell
```bash
kquitapp6 plasmashell
kstart plasmashell
```

# Add sounds

The plasmoid does not include any sounds by itself as part of the installation,
users can however add arbitrary sounds to it.

To add sounds to the plasmoid's library, simply copy your favourite noise audio
files and their corresponding icons to the sound folder (its default location
is `/usr/share/anoise/sounds` but it can be customized in the settings).
Supported extensions are `.ogg`, `.flac`, `.mp3`, `.wav`, Use snake case for
the file names (it will be automatically converted to sentence case in the UI),
and use the same name (besides different file extension) for each audio file
and its corresponding icon.

For example, the layout of the sound folder should look like:
```
/usr/share/anoise/sounds
                  |- coffee_shop.ogg
                  |- coffee_shop.png
                  |- fire.ogg
                  |- fire.png
                  |- forest.ogg
                  |- forest.png
```

Free noises in a ready-to-use format for this plasmoid can be found in the
[anoise project](https://github.com/costales/anoise), which was a source of
inspiration for this plasmoid.

Arch Linux users can get a collection of user-generated sounds to work
out-of-the-box by installing the `anoise-community-extension` packages from the
AUR ([1](https://aur.archlinux.org/packages/anoise-community-extension1),
[2](https://aur.archlinux.org/packages/anoise-community-extension2),
[3](https://aur.archlinux.org/packages/anoise-community-extension3),
[4](https://aur.archlinux.org/packages/anoise-community-extension4),
[5](https://aur.archlinux.org/packages/anoise-community-extension5)).

# Why are there no sounds bundled with the project?

This project intentionally avoids bundling any sounds, for a few reasons:
* I prefer to avoid shipping multimedia assets under other people's or project's
  intellectual property (even under permissive licenses).
* _De gustibus non est disputandum_. The choice is quintessentially a matter of
  taste, and no two users will have the same taste. Building a library of
  sounds that is variegated enough to appeal to most users would be
  non-trivial, and a large library would consume resources for sounds users
  might not like or want. Users should not pay for what they not need.
* I do not want to keep multimedia assets under version control in git, but I
  currently also want to avoid relying on a third party storage and having to
  integrate it in the plasmoid's build process.

For these reasons, pull requests trying to add multimedia assets to the project
will be rejected.

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
from bad configuration of the multimedia back-end.

# License
The project is licensed under GPL 3. See [LICENSE](./LICENSE)
file for the full license.
