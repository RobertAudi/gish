function gap --description="git add patch"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  set -l arguments

  set -l cmd "`which git` diff --name-only"

  if test (count $argv) -gt 0
    set arguments (gish find -c $cmd $argv)

    if test (count $arguments) -eq 0
      set_color red
      echo "No matches found"
      set_color normal
      return 0
    end
  end

  command git add -p $arguments
  gs
end
