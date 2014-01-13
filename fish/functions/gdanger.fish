function gdanger --description="git reset --hard"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  set -l revision

  if test (count $argv) -eq 0
    set revision "HEAD"
  else
    set revision $argv[1]
  end

  command git reset --hard $revision
end
