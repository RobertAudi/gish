function gcl --description="git clone"
  if test (count $argv) -eq 0
    set -l clipboard

    type pbpaste > /dev/null

    if test $status -eq 1
      # NOTE: Everything beyond this point is not tested
      type xsel > /dev/null

      if test $status -eq 1
        type xclip > /dev/null

        if test $status -eq 1
          set_color red
          echo "No clipboard management command was found"
          echo "pbpaste, xsel or xclip required"
          set_color normal

          return 1
        else
          set clipboard (command xclip -selection clipboard -o)
        end
      else
        set clipboard (command xsel --clipboard --output)
      end
    else
      set clipboard (pbpaste)
    end

    command git clone $clipboard > /dev/null ^ /dev/null

    if test $status -gt 0
      set_color red
      echo "Invalid git repository in clipboard"
      set_color normal
      return 128
    end

    set_color green
    echo "Clone repository: $clipboard"
    set_color normal
  else
    command git clone $argv > /dev/null ^ /dev/null

    if test $status -gt 0
      set_color red
      echo "Unable to find the repository $argv"
      set_color normal
      return 128
    end

    set_color green
    echo "Clone repository: $argv"
    set_color normal
  end
end
