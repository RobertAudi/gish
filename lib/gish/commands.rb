module Gish
  module Commands
    class BasicCommand
      EXECUTION_METHOD = :execute!

      attr_reader :arguments, :options, :valid_options

        @project_root = File.directory?(File.join(Dir.getwd, ".git")) ? Dir.getwd : `\git rev-parse --show-toplevel 2> /dev/null`.strip
      def initialize(arguments = [], options = {})

        if @project_root.empty?
          # TODO: Set the appropriate status code here (128)
          raise RuntimeError, "Directory is not a git repository (#{Dir.getwd})"
        end

        @arguments, @options = validate arguments: arguments, options: options
      end

      private

      def validate(collection = {})
        arguments ||= collection[:arguments]
        options   ||= collection[:options]

        # TODO: Validate arguments

        options.keys.each do |o|
          unless self.valid_options.include?(o)
            raise ArgumentError, "Invalid option (#{o})"
          end
        end

        return arguments, options
      end
    end
  end
end

Dir[File.dirname(File.realpath(__FILE__)) + "/commands/*.rb"].each do |f|
  require f
end
