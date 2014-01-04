function gap --description="git add patch"
  set -l arguments

  set -l cmd "command git diff --name-only"

  if test (count $argv) -gt 0
    set arguments (gish find -c $cmd $argv)

    if test -z $arguments
      set_color red
      echo "No matches found"
      set_color normal
      return 0
    end
  end

  command git add -p $arguments
end
