module Gish
  module Commands
    class AddCommand < BasicCommand
      include Gish::Helpers::FileHelper
      include Gish::Concerns::Findable

      def initialize(arguments = [], options = {})
        @valid_options = [
          :untracked_only,
          :tracked_only,
          :from_root,
          :greedy
        ]

        arguments = ["."] if arguments.empty?

        super arguments, options
      end

      define_method EXECUTION_METHOD do
        tracked_only   = (options.has_key?(:tracked_only))
        untracked_only = (options.has_key?(:untracked_only))
        from_root      = (options.has_key?(:from_root))
        greedy         = (options.has_key?(:greedy))


        # Can't have both options at the same time
        if tracked_only && untracked_only
          return "Cannot use both tracked only and untracked only filters", Gish::INVALID_OPTION
        end

        status = `\git status --porcelain`.split("\n")
        status.delete_if { |f| f =~ /\A. / }

        return "", Gish::OK if status.empty?

        files = {
          unprocessed: {
            raw: [],
            full: []
          },
          found: [],
          add: [],
          remove: []
        }

        # Remove untracked files and replace the path to other files by a relative one
        status.delete_if { |f| f[0..1] == "??" }
        status.map! do |f|
          state = f[0..2]
          relative_path(Dir.getwd, File.join(@project_root, f[3..-1])).prepend(state)
        end

        # Expand untracked directories and
        # add them back to the status
        status << untracked_files
        status.flatten!

        status.keep_if   { |f| f[0..1] == "??" } if untracked_only
        status.delete_if { |f| f[0..1] == "??" } if tracked_only

        # If not in the project root, remove the files in other directories
        if @project_root != Dir.getwd && !from_root
          oldwd = Dir.getwd
          status.keep_if { |f| File.realpath(f[3..-1]) =~ /\A#{oldwd}/ }
        end

        status.each do |f|
          files[:unprocessed][:raw]  << f[3..-1]
          files[:unprocessed][:full] << { status: f[0..1], file: f[3..-1] }
        end

        unless arguments.first == "."
          arguments.each do |arg|
            files[:found] << fuzzy_find(files[:unprocessed][:raw], arg, greedy: greedy)
          end

          files[:found].flatten!

          files[:unprocessed][:raw] = files[:found]
          files[:unprocessed][:full].keep_if { |f| files[:found].grep(/\A#{f[:file]}\Z/).count > 0 }
        end

        if untracked_only
          files[:add] = files[:unprocessed][:raw]
        else
          files[:unprocessed][:full].each do |f|
            if f[:status] =~ /D/
              files[:remove] << f[:file]
            else
              files[:add] << f[:file]
            end
          end
        end

        `\git add #{files[:add].join(" ")}` unless files[:add].empty?
        `\git rm #{files[:remove].join(" ")}` unless files[:remove].empty?

        return "", Gish::OK
      end

      private

      def untracked_files
        oldwd = Dir.getwd
        Dir.chdir(@project_root)

        files = `\git ls-files --other --exclude-standard`.split("\n")
        files.map! { |f| relative_path(oldwd, File.join(@project_root, f)).prepend("?? ") }

        Dir.chdir(oldwd)

        files
      end
    end
  end
end
