#        _     _     _              _
#   __ _(_)___| |__ | |_ __ _ _ __ | | __
#  / _` | / __| '_ \| __/ _` | '_ \| |/ /
# | (_| | \__ \ | | | || (_| | | | |   <
#  \__, |_|___/_| |_|\__\__,_|_| |_|_|\_\
#  |___/
#

set -gx GISH_DIR (dirname (status -f))
set -gx GISH_STATUS_MAX_CHANGES "150"

set fish_function_path $GISH_DIR/functions $fish_function_path
set fish_user_paths $GISH_DIR/bin $fish_user_paths
