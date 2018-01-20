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
    return str.replace(/\.[^\.]+$/, "");
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
    return dir.trim().replace(/\/*$/, "") + "/";
}

/*!
 * Compute the volume of an audio stream, given its volume.
 * Multiply it by the global volume, and apply nonlinear scaling.
 */
function computeVolume(componentVolume) {
    var volume = componentVolume * globalVolumeSlider.value;
    volume /= main.maxVolume * main.maxVolume;
    return QtMultimedia.convertVolume(volume,
                                      QtMultimedia.LogarithmicVolumeScale,
                                      QtMultimedia.LinearVolumeScale);
}

/*!
 * Play all the audio streams for the noise components.
 * @param  value Boolean, play if true, stop if false, toggle if undefined.
 */
function play(value) {

    noiseComponents.playing = (value === undefined) ? !noiseComponents.playing : value;

    if (noiseComponents.playing) {
        playButton.iconName = "media-playback-pause";
    }
    else {
        playButton.iconName = "media-playback-start";
    }

    Object.keys(noiseComponents.playableList).forEach(function(key, index) {
        noiseComponents.playableList[key].play(noiseComponents.playing);
    });
}
