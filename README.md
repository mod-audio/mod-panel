# MOD Panel


mod-panel is a simple control panel to start MOD UI and SDK services.



Build
---------


Install prerequisite PyQt - on Ubuntu(tested with 21.10):

    sudo apt install pyqt5-dev 

Setup git submodules:

    git submodule init
    git submodule update


Build it with make:

    make


Now go into source/mod-sdk and follow the build/install instructions there.

When this is successfull, you can run the panel with:

    source/mod-panel


Screenshot
---------------

![Screenshot](https://raw.githubusercontent.com/portalmod/mod-panel/master/screenshot.png)
