function gc --description="git commit"
  if test (count (command git status --porcelain | command grep "^[^ ?]")) -eq 0
    set_color yellow
    echo "Nothing to commit..."
    set_color normal
    return 1
  end

  set -l arguments

  set -l cmd "command git diff --cached --name-only"

  eval "$GISH_DIR/include/parse $argv"

  if test (count $ARGV) -gt 0
    set arguments (gish find -c $cmd $ARGV)

    if test -z $arguments
      set_color red
      echo "No matches found"
      set_color normal
      return 0
    end
  end

  command git commit $OPTV $ARGV
  gs
end
