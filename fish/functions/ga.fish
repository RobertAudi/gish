function ga --description="Fuzzy git add"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  gish add $argv

  if test $status -eq 0
    echo ""
    gs
  end
end
