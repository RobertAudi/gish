module Gish
  module Commands
    class AddCommand < BasicCommand
      def initialize(arguments = [], options = {})
        @valid_options = [
          :untracked_only,
          :tracked_only
        ]

        super arguments, options
      end

      define_method EXECUTION_METHOD do
        status = `\git status --porcelain`
        tracked_only   ||= !(options.has_key?(:tracked_only))
        untracked_only ||= !(options.has_key?(:untracked_only))

        if status.empty? || status.split("\n").grep(/\A.[^ ]/).empty?
          puts yellow message: "Nothing to add..."
          return
        end

      end
    end
  end
end
