export BLACK="\033[0;30m"
export RED="\033[0;31m"
export GREEN="\033[0;32m"
export YELLOW="\033[0;33m"
export BLUE="\033[0;34m"
export MAGENTA="\033[0;35m"
export CYAN="\033[0;36m"
export LIGHT_GRAY="\033[0;37m"
export GRAY="\033[1;30m"
export LIGHT_RED="\033[1;31m"
export LIGHT_GREEN="\033[1;32m"
export LIGHT_YELLOW="\033[1;33m"
export LIGHT_BLUE="\033[1;34m"
export LIGHT_MAGENTA="\033[1;35m"
export LIGHT_CYAN="\033[1;36m"
export WHITE="\033[1;37m"
export NO_COLOR="\033[0m"

parse() {
  options=()
  arguments=()

  for arg
  do
    if [[ $arg = -* ]]
    then
      options+=("$arg")
    else
      arguments+=("$arg")
    fi
  done

  export OPTV="${options[@]}"
  export ARGV="${arguments[@]}"
}
