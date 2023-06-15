#!/bin/bash

set -e

cd $(dirname "${0}")/browsepy

# setup environment variables
WORKDIR=${WORKDIR:=~/mod-workdir}

export MOD_USER_FILES_DIR="${WORKDIR}/user-files"

# if coming through PawPaw, reset PATH
if [ -n "${OLD_PATH}" ]; then
    export PATH="${OLD_PATH}"
else
    export PATH="~/.local/bin:${PATH}"
fi

# check for pip3 tool
if ! command -v pip3 >/dev/null; then
    echo "pip3 tool not available, cannot continue"
    exit 1
fi

# install virtualenv as needed
if ! virtualenv --version 2>/dev/null; then
    pip3 install virtualenv
fi

# activate virtualenv
virtualenv browsepy-env
source browsepy-env/bin/activate

# install required mod-ui dependencies in virtualenv
pip3 install -r requirements.txt

# create initial directories
mkdir -p "${MOD_USER_FILES_DIR}/Audio Loops"
mkdir -p "${MOD_USER_FILES_DIR}/Audio Recordings"
mkdir -p "${MOD_USER_FILES_DIR}/Audio Samples"
mkdir -p "${MOD_USER_FILES_DIR}/Audio Tracks"
mkdir -p "${MOD_USER_FILES_DIR}/MIDI Clips"
mkdir -p "${MOD_USER_FILES_DIR}/MIDI Songs"
mkdir -p "${MOD_USER_FILES_DIR}/Reverb IRs"
mkdir -p "${MOD_USER_FILES_DIR}/Speaker Cabinets IRs"
mkdir -p "${MOD_USER_FILES_DIR}/Hydrogen Drumkits"
mkdir -p "${MOD_USER_FILES_DIR}/SF2 Instruments"
mkdir -p "${MOD_USER_FILES_DIR}/SFZ Instruments"
mkdir -p "${MOD_USER_FILES_DIR}/Aida DSP Models"
mkdir -p "${MOD_USER_FILES_DIR}/NAM Models"

# start browsepy inside virtualenv
exec python3 -c "from browsepy.__main__ import main; main()" --directory "${MOD_USER_FILES_DIR}" --upload "${MOD_USER_FILES_DIR}" --removable "${MOD_USER_FILES_DIR}" 127.0.0.1 8081
