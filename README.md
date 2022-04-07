# MOD Panel

mod-panel is a simple control panel to start MOD Host + UI and SDK services.

## Usage

Simply clone this repository recursively (either with `git clone --recursive` or `git submodule --init --update` afterwards), build and run it:

```sh
make
./source/mod-panel
```

Afterwards simply click on "Start" for MOD Host + UI or SDK, and then its ">" button to open a browser on the predefined location.

If you have used [mod-plugin-builder](https://github.com/moddevices/mod-plugin-builder) before to build `x86_64` plugin binaries, the plugin path is adjusted automatically to it.  
You can always override `LV2_PATH` environment variable to a custom location of your choosing.

Some notes:

- Installation via typical `make install` is not supported
- The use of mod-host requires [JACK](https://jackaudio.org/) to be installed and running

### Dependencies

ALSA, JACK and LV2 (lilv) libraries are required, as well as PyQt5 for the UI.  
Python's `virtualenv` and `pip` is used to get the required versions of python libraries, as they cannot be too new or too old.
(so Linux distribution packages are often not usable here)

## Screenshot

![Screenshot](https://raw.githubusercontent.com/portalmod/mod-panel/master/screenshot.png)
