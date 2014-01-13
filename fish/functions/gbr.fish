function gbr --description="Open the Github page for the current repo"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  type hub > /dev/null

  if test $status -gt 0
    set_color red
    echo "You need to install `hub` to use this command"
    set_color normal

    return 1
  end

  command hub browse
end
