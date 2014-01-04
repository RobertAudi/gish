function gs --description="git status"
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
