#!/bin/bash

set -e

cd $(dirname "${0}")/mod-ui

export MOD_DEV_ENVIRONMENT=0

# TODO setup MOD_DATA_DIR
# TODO setup LV2_PATH
# TODO setup MOD_LOG

virtualenv modui-env
source modui-env/bin/activate
pip3 install -r requirements.txt

exec python3 ./server.py
