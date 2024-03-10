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

"use strict";

/* global
 * QtMultimedia:readonly,
 * i18n:readonly,
 * main:readonly,
 * maxVolume:readonly,
 * noiseComponentsModel:readonly,
 * plasmoid:readonly,
 */

/*!
 * Name for the volume icon, according to current volume value.
 * @param  volume Numeric volume value
 * @param  muted  Boolean, true if mute
 * @return Icon name
 */
function volumeIcon(volume, muted) {
    var iconName = "audio-volume";
    var value = volume / maxVolume;
    if (muted || value <= 0.0) {
        iconName += "-muted";
    } else if (value <= 0.25) {
        iconName += "-low";
    } else if (value <= 0.75) {
        iconName += "-medium";
    } else {
        iconName += "-high";
    }
    return iconName;
}

/*!
 * Strip extension from a file name.
 */
function toName(str) {
    return str.replace(/\.[^.]+$/, "");
}

/*!
 * Strip extension, capitalise, and replace underscore with spaces.
 */
function toPrettyName(str) {
    str = toName(str);
    str = str.charAt(0).toUpperCase() + str.slice(1);
    return str.replace(/_/g, " ");
}

/*!
 * Return the absolute path of the audio file.
 */
function toAudioName(filename) {
    return dataDirectory() + filename;
}

/*!
 * Return the .png image corresponding to the audio file.
 */
function toImageName(filename) {
    return dataDirectory() + toName(filename) + ".png";
}

/*!
 * Return the full path of the data directory from settings.
 */
function dataDirectory() {
    var dir = plasmoid.configuration.noiseDataDirectory;
    return "file://" + dir.trim().replace(/\/*$/, "") + "/";
}

/*!
 * Compute the volume of an audio stream, given its volume.
 * Multiply it by the global volume, and apply nonlinear scaling.
 */
function computeVolume(componentVolume) {
    const volume = (componentVolume * plasmoid.configuration.globalVolume) / (main.maxVolume ** 2);
    return (volume > 0.99) ? 1.0 : -Math.log(1.0 - volume) / Math.log(100.0);
}

/*!
 * Serialise a QML DataModel object.
 */
function serialiseDataModel(dataModel) {
    var data = [];
    for (var i = 0; i < dataModel.count; ++i) {
        data.push(dataModel.get(i));
    }
    return JSON.stringify(data);
}

/*!
 * Deserialise a QML DataModel object.
 */
function deserialiseDataModel(dataString, dataModel) {
    if (dataString) {
        dataModel.clear();
        var data = JSON.parse(dataString);
        for (var i = 0; i < data.length; ++i) {
            dataModel.append(data[i]);
        }
    }
}

/*!
 * Save current noise component settings.
 */
function saveComponents() {
    plasmoid.configuration.noiseComponents = serialiseDataModel(noiseComponentsModel);
}

/*!
 * Restore noise components from settings.
 */
function restoreComponents() {
    try {
        deserialiseDataModel(plasmoid.configuration.noiseComponents, noiseComponentsModel);
    }
    catch (e) {
        console.log(e);
        plasmoid.configuration.noiseComponents = "[]";
    }
}
