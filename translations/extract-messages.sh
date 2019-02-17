#!/bin/sh
set -euo pipefail

BASEDIR=".."                                                          # root of translatable sources
PROJECT="plasma_applet_org.kde.plasma.ambientnoise"                   # project name
BUGADDR="http://github.com/m-pilia/plasma-applet-ambientnoise/issues" # MSGID-Bugs
WDIR="$(pwd)/po"		                                              # working dir

echo "Extracting messages"
find ${BASEDIR} -name '*.qml' -o -name '*.js' | sort > "${WDIR}"/infiles.list
cd "${WDIR}" || exit 1
xgettext --from-code=UTF-8 -C -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 -ktr2i18n:1 \
	-kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kaliasLocale -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3 \
	--msgid-bugs-address="${BUGADDR}" \
	--files-from=infiles.list -D ${BASEDIR} -D "${WDIR}" -o ${PROJECT}.pot || { echo "error while calling xgettext. aborting."; exit 1; }
echo "Done extracting messages"


echo "Merging translations"
catalogs=$(find . -name '*.po')
for cat in $catalogs; do
  echo "$cat"
  msgmerge -o "$cat".new "$cat" ${PROJECT}.pot
  mv "$cat".new "$cat"
done
echo "Done merging translations"


echo "Cleaning up"
cd "${WDIR}" || exit 1
rm infiles.list
echo "Done"
