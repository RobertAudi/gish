function gcob --description="git checkout new branch"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 128
  end

  if test (count $argv) -lt 1
    set_color red
    echo "You need to specify a name for the new branch"
    set_color normal
    return 129
  end

  if test (count (command git branch --no-color | command sed -E "s/^\*? ? //g" | command grep -E "^$argv\$")) -eq 1
    set_color red
    echo "A branch named '$argv' already exists"
    set_color normal
    return 128
  end

  command git checkout -b $argv > /dev/null ^ /dev/null

  gs

  set_color green
  echo "Swiched to a new branch '$argv'"
  set_color normal
end
