module Gish
  module Commands
    LIST = Dir[File.dirname(File.realpath(__FILE__)) + "/commands/*_command.rb"].map { |c| c.split("/").last.sub(/_command\.rb/, "") }

    class BasicCommand
      EXECUTION_METHOD = :execute!

      attr_reader :arguments, :options, :valid_options

      def initialize(arguments = [], options = {})
        @project_root = File.directory?(File.join(Dir.getwd, ".git")) ? Dir.getwd : `\git rev-parse --show-toplevel 2> /dev/null`.strip

        if @project_root.empty?
          return "Directory is not a git repository (#{Dir.getwd})", Gish::NOT_A_REPO
        end

        @valid_options ||= []
        @arguments, @options = validate arguments: arguments, options: options
      end

      private

      def validate(collection = {})
        arguments ||= collection[:arguments]
        options   ||= collection[:options]

        # TODO: Validate arguments

        options.keys.each do |o|
          unless self.valid_options.include?(o)
            return "Invalid option (#{o})", Gish::INVALID_OPTION
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
