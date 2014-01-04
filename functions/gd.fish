function gd --description="git diff"
  set -l arguments

  set -l cmd "command git status --porcelain | sed 's/^.\{3\}//g'"

  if test (count $argv) -gt 0
    set arguments (gish find -c $cmd $argv)
  end

  command git diff $arguments
end
