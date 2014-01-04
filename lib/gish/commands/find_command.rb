module Gish
  module Commands
    class FindCommand < BasicCommand
      include Gish::Concerns::Findable

      def initialize(arguments, options = {})
        @valid_options = [
          :directory,
          :greedy,
          :refine
        ]

        super arguments, options
      end

      define_method EXECUTION_METHOD do
        return "Query required\n", Gish::ERROR if arguments.empty?

        greedy = (options.has_key?(:greedy))
        refine = (options.has_key?(:refine))
        directory = options[:directory] || Dir.getwd

        files = Dir.glob(File.join(File.realpath(directory), "**", "*"))
        found = []

        if refine
          arguments.each do |arg|
            files = fuzzy_find(files, arg, greedy: greedy)
          end
        else
          arguments.each do |arg|
            found << fuzzy_find(files, arg, greedy: greedy)
          end

          files = found.flatten.uniq
        end

        files.map! { |f| "\"#{f}\"" }

        return files.join(" "), Gish::OK
      end
    end
  end
end
