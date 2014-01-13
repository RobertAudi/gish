function grm --description="git rm"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  if test (count $argv) -eq 0
    set_color red
    echo "You need to list the files to remove"
    set_color normal
    return 129
  end

  set -l arguments

  set -l cmd "command git ls-files"

  eval "$GISH_DIR/include/parse $argv"

  if test (count $ARGV) -gt 0
    set arguments (gish find -c $cmd $ARGV)
  end

  if test (count $arguments) -eq 0
    set_color red
    echo "No matches found"
    set_color normal
    return 0
  end

  command git rm $OPTV $arguments > /dev/null

  gs
end
