function gcd --description="Navigate to the root of the git repository"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  cd (command git rev-parse --show-toplevel)
end
