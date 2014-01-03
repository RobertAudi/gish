require "optparse"

module Gish
  class OptionParser
    OPTIONS = {
      add: [
        "Usage: gish add [<option> ...] [<query> ...]",
        {
          short: "-u",
          long: "--untracked-only",
          description: "Untracked files only",
          key: :untracked_only
        },
        {
          short: "-t",
          long: "--tracked-only",
          description: "Tracked files only",
          key: :tracked_only
        },
        {
          short: "-r",
          long: "--from-root",
          description: "Act as if in the root of the repo",
          key: :from_root
        },
        {
          short: "-g",
          long: "--greedy",
          description: "Filter the files greedily",
          key: :greedy
        }
      ]
    }


    def initialize(command)
      @command = command.to_sym
    end

    def parse(args)
      options = {}
      return options unless OPTIONS.has_key?(@command)

      command_options = OPTIONS[@command]

      option_parser = ::OptionParser.new do |opts|
        opts.banner = command_options.shift
        opts.separator ""

        command_options.each do |opt|
          opts.on(opt[:short], opt[:long], opt[:description]) do
            options[opt[:key]] = true
          end
        end
      end

      option_parser.parse!(args)
      options
    end
  end
end
