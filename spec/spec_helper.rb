require "minitest/autorun"
require "minitest/pride"

require "pp"

def require_gem(gem)
  begin
    require gem
  rescue LoadError
    puts "`#{gem}` needed to run specs."
    puts "Run `rake gish:specs:setup` to install"
    puts "all the development dependencies."
    exit 1
  end
end
