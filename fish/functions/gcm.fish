function gcm --description="git commit with message"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  if test (count (command git status --porcelain | command grep "^[^ ?]")) -eq 0
    set_color yellow
    echo "Nothing to commit..."
    set_color normal
    return 1
  end

  if test (count $argv) -eq 0
    set_color red
    echo "Arborting commit due to empty commit message"
    set_color normal
    return 1
  end

  command git commit -m "$argv"
  gs
end
