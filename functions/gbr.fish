function gbr --description="Open the Github page for the current repo"
  type hub > /dev/null

  if test $status -gt 0
    set_color red
    echo "You need to install `hub` to use this command"
    set_color normal

    return 1
  end

  command hub browse
end
