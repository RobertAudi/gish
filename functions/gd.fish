function gd --description="git diff"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  set -l arguments

  set -l cmd "command git status --porcelain | sed 's/^.\{3\}//g'"

  if test (count $argv) -gt 0
    set arguments (gish find -c $cmd $argv)

    if test -z $arguments
      set_color red
      echo "No matches found"
      set_color normal
      return 0
    end
  end

  command git diff $arguments
end
