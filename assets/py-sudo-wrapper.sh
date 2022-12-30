#!/bin/sh

# prepend python 3.11 to PATH environment variable
export PATH=/opt/ft/workspaces/ext_sd/mmcblk1/python-3.11/bin:$PATH

# prepend lib path of python 3.11 to LD_LIBRARY_PATH environment variable
export LD_LIBRARY_PATH=/opt/ft/workspaces/ext_sd/mmcblk1/python-3.11/lib:/$LD_LIBRARY_PATH

# run the python script, which is provided as the first argument to this shell script ($1)
python3 $1
