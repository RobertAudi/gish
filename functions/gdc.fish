function gdc --description="git diff cached files"
  set -l arguments

  set -l cmd "command git diff --cached --name-only"

  if test (count $argv) -gt 0
    set arguments (gish find -c $cmd $argv)
  end

  command git diff --cached -- $arguments
end
