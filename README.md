# Ambient noise applet for Plasma 5
![screenshot](https://user-images.githubusercontent.com/8300317/27260682-155864dc-5432-11e7-8afa-4327cac14e32.png)

This applet for the Plasma desktop allows to reproduce ambient noise.
Multiple noise components can be combined, controlling their individual volume.
The applet reads noise files and their icons from a given, customisable folder.
The noise and the icon must be in the same folder and share the same name,
except for the file extension.
Free noises can be found in the [anoise project](http://anoise.tuxfamily.org/).

# Build and install
The applet can be installed locally with
```
kpackagetool5 -t Plasma/Applet --install plasmoid
```
or globally with
```
cmake . -DCMAKE_INSTALL_PREFIX=`kf5-config --prefix`
make
sudo make install
```
To see the plasmoid, you may need to restart plasmashell.

# License
The project is licensed under GPL 3. See [LICENSE](./LICENSE)
file for the full license.
