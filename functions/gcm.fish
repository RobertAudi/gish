function gcm --description="git commit with message"
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
