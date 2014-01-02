module Gish
  module Commands
    class AddCommand < BasicCommand
      def initialize(arguments = [], options = [])
        @valid_options = [
          %w(-u --untracked-only),
          %w(-t --tracked-only)
        ]

        super arguments, options
      end

      define_method EXECUTION_METHOD do
        status = `\git status --porcelain`

        if status.empty? || status.split("\n").grep(/\A.[^ ]/).empty?
          puts yellow message: "Nothing to add..."
          return
        end

        tracked_only   ||= (options.grep(/\A-{1,2}t/).count == 0)
        untracked_only ||= (options.grep(/\A-{1,2}u/).count == 0)
      end
    end
  end
end
