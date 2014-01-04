# TODO: require the stuff below only if the debug mode is ON
require "pp"

module Gish
  OK = 0
  ERROR = 1
  NOT_A_COMMAND = 128
  NOT_A_REPO = 128
  INVALID_OPTION = 129
  TOO_MANY_CHANGES = 49
  NO_CHANGES = 34
end

require_relative "./gish/version"
require_relative "./gish/helpers"
require_relative "./gish/concerns"
require_relative "./gish/commands"
require_relative "./gish/task"
require_relative "./gish/option_parser"
