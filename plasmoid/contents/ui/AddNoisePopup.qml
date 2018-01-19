/*
 * This file is part of Ambient Noise.
 * Copyright (C) Martino Pilia <martino.pilia@gmail.com>, 2017
 *
 * Ambient Noise is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Ambient Noise is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Ambient Noise. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "../js/scripts.js" as Js

ScrollView
{
    ListView {
        model: FolderListModel {
            id: folderModel
            folder: Js.dataDirectory()
            nameFilters: ["*.ogg", "*.flac", "*.mp3", "*.wav"]
            showDirs: false
        }

        delegate: PlasmaComponents.ListItem {
            separatorVisible: true

            RowLayout {

                Image {
                    source: Js.toImageName(fileName)
                    fillMode: Image.PreserveAspectFit
                    Layout.preferredHeight: units.iconSizes.medium
                    Layout.preferredWidth: units.iconSizes.medium
                    Layout.alignment: Qt.AlignVCenter
                }

                PlasmaComponents.Label {
                    id: fileText
                    text: Js.toPrettyName(fileName)
                    Layout.alignment: Qt.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        componentsModel.append({
                            "filename": fileName,
                            "tag": componentsModel.nextAdd
                        });
                        stack.pop()
                    }
                }
            }
        }
    }
}
