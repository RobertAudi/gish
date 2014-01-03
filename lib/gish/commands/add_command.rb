module Gish
  module Commands
    class AddCommand < BasicCommand
      include Gish::Concerns::Findable

      def initialize(arguments = [], options = {})
        @valid_options = [
          :untracked_only,
          :tracked_only,
          :from_root
        ]

        arguments = ["."] if arguments.empty?

        super arguments, options
      end

      define_method EXECUTION_METHOD do
        tracked_only   ||= (options.has_key?(:tracked_only))
        untracked_only ||= (options.has_key?(:untracked_only))
        from_root ||= (options.has_key?(:from_root))

        # Can't have both options at the same time
        if tracked_only && untracked_only
          raise ArgumentError, "Cannot use both tracked only and untracked only filters"
        end

        status = `\git status --porcelain`.split("\n")
        status.delete_if { |f| f =~ /\A. / }

        raise RuntimeError, "Nothing to add" if status.empty?

        files = {
          unprocessed: {
            raw: [],
            full: []
          },
          found: [],
          add: [],
          remove: []
        }

        # Expand untracked directories
        status.delete_if { |f| f[0..1] == "??" }
        status << untracked_files
        status.flatten!

        status.keep_if   { |f| f[0..1] == "??" } if untracked_only
        status.delete_if { |f| f[0..1] == "??" } if tracked_only

        # If not in the project root, remove the files in other directories
        if @project_root != Dir.getwd && !from_root
          oldwd = Dir.getwd
          Dir.chdir(@project_root)
          status.keep_if { |f| File.realpath(f[3..-1]) =~ /\A#{oldwd}/ }
          Dir.chdir(oldwd)
        end

        status.each do |f|
          files[:unprocessed][:raw]  << f[3..-1]
          files[:unprocessed][:full] << { status: f[0..1], file: f[3..-1] }
        end

        unless arguments.first == "."
          arguments.each do |arg|
            # TODO: Pass the greedy option as well
            files[:found] << fuzzy_find(files[:unprocessed][:raw], arg)
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
      end

      private

      def untracked_files
        untracked_files = `\git ls-files --other --exclude-standard`.split("\n")
        untracked_files.map! { |f| f.prepend("?? ") }

        # The next two lines are necessary because of a bug in git
        dir = Dir.getwd.sub(/#{@project_root}\/?/, "")
        untracked_files.map! { |f| dir.empty? ? f : f[0..2] + File.join(dir, f[3..-1]) }

        untracked_files
      end
    end
  end
end
