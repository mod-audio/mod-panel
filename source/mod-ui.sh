#!/bin/bash

set -e

cd $(dirname "${0}")/mod-ui

export MOD_DEV_ENVIRONMENT=0

# TODO setup MOD_DATA_DIR
# TODO setup LV2_PATH
# TODO setup MOD_LOG

# if coming through PawPaw, reset PATH
if [ -n "${OLD_PATH}" ]; then
    export PATH="${OLD_PATH}"
fi

# install virtualenv as needed
if ! virtualenv --version 2>/dev/null; then
    pip3 install virtualenv
fi

# activate virtualenv
virtualenv modui-env
source modui-env/bin/activate

# install required mod-ui dependencies in virtualenv
pip3 install -r requirements.txt

# start mod-ui inside virtualenv
exec python3 ./server.py
