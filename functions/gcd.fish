function gcd --description="Navigate to the root of the git repository"
  cd (command git rev-parse --show-toplevel)
end
