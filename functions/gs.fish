function gs --description="git status"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  gish status $argv

  if test $status -eq 49
    echo ""
    set_color red
    echo "Falling back to the basic `git status`"
    set_color normal

    echo ""

    command git status
  end
end
