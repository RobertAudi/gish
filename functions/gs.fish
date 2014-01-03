function gs --description="git status"
  gish status $argv

  # FIXME: The wrong status code is being received...
  # 429 vs 173
  if test $status -gt 0
    echo ""
    set_color red
    echo "Falling back to the basic `git status`"
    set_color normal

    echo ""

    command git status
  end
end
