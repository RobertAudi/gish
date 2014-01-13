function gl --description="git log"
  if test -z (command git rev-parse --show-toplevel 2> /dev/null)
    set_color red
    echo "Not in a git repository"
    set_color normal
    return 1
  end

  command ls .git/logs > /dev/null ^/dev/null

  if test $status -ne 0
    set_color red
    echo "You didn't commit anything yet..."
    set_color normal
    return 1
  end

  command git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $argv
end
