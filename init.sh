#         _     _
#    __ _(_)___| |__
#   / _` | / __| '_ \
#  | (_| | \__ \ | | |
#   \__, |_|___/_| |_|
#   |___/
#               by Aziz Light
#


export GISH_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
export GISH_STATUS_MAX_CHANGES=150

source $GISH_DIR/sh/utility.sh
source $GISH_DIR/sh/functions.sh

export PATH=$GISH_DIR/bin:$PATH
