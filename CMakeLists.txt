cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(AmbientNoise)

find_package(ECM 6.0.0 REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(KDEInstallDirs6)
include(KDECMakeSettings)
include(KDECompilerSettings)

find_package(Qt6 6.5.0 CONFIG REQUIRED Quick Multimedia)
find_package(KF6 6.0.0 REQUIRED)
find_package(Plasma REQUIRED)

add_subdirectory(icons)
add_subdirectory(translations)

plasma_install_package(plasmoid org.kde.plasma.ambientnoise)
