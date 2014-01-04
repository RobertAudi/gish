module Gish
  module Commands
    class StatusCommand < BasicCommand
      include Gish::Helpers::RainbowHelper

      COLORS = {
        reset:     [:white,  { bold: false }],
        deleted:   [:red,    { bold: false }],
        modified:  [:green,  { bold: false }],
        added:     [:yellow, { bold: false }],
        renamed:   [:blue,   { bold: false }],
        copied:    [:yellow, { bold: false }],
        retyped:   [:purple, { bold: false }],
        untracked: [:cyan,   { bold: false }],
        dark:      [:black,  { bold: true  }],
        branch:    [:gray,   { bold: true  }],
        header:    [:white,  { bold: false }]
      }

      GROUPS = {
        staged:    { color: :yellow, message:       "Changes to be committed" },
        unmerged:  { color: :red,    message:                "Unmerged paths" },
        unstaged:  { color: :green,  message: "Changes not staged for commit" },
        untracked: { color: :cyan,   message:               "Untracked files" }
      }

      def initialize(arguments = [], options = {})
        @valid_options = [
        ]

        super arguments, options
      end

      define_method EXECUTION_METHOD do
        status = `\git status --porcelain`.split("\n")

        if status.count > ENV["GISH_STATUS_MAX_CHANGES"].to_i
          return "Too many changes", Gish::TOO_MANY_CHANGES
        end

        git_branch_output = `\git branch -v 2> /dev/null`
        branch = git_branch_output[/^\* (\(no branch\)|[^ ]*)/, 1]
        ahead  = git_branch_output[/^\* [^ ]* *[^ ]* *\[ahead ?(\d+).*\]/, 1]
        behind = git_branch_output[/^\* [^ ]* *[^ ]* *\[.*behind ?(\d+)\]/, 1]

        difference = ["-#{behind}", "+#{ahead}"].select{ |diff| diff.length > 1 }.join("/")
        if difference.length > 0
          diff = ""
          diff << dark_color(" | ")
          diff << added_color(difference)
          difference = diff
        else
          difference = ""
        end

        output = ""
        output << dark_color("#")
        output << " On branch: "
        output << branch_color(branch)
        output << difference
        output << dark_color(" | ")

        if status.empty?
          output << modified_color("No changes (working directory clean)\n")
          return output, Gish::OK
        end

        output << change_string_for(status).gsub(/(\d+)/, modified_color('\1'))
        output << dark_color("\n#\n")

        # FIXME: Check if the first arg is a valid filter
        # TODO: Replace the filter conditional thingy below by a set of options
        if !arguments.empty? && GROUPS.keys.map(&:to_s).grep(/\A#{arguments.first}\Z/).empty?
          output.prepend red("Valid filters: staged, unmerged, unstaged, untracked\n\n")
          output.prepend red("Invalid status filter: #{arguments.first}\n")
          valid_status_filter = false
        else
          valid_status_filter = true
        end

        changes = changes_for status

        GROUPS.each do |group, spec|
          heading = spec[:message]


          # Allow filtering by specific group (by string or integer)
          if !valid_status_filter || arguments.empty? || arguments.first == group.to_s
            unless changes[group].empty?
              output << send("#{group}_group_color", "\u27A4".encode("utf-8"), bold: true)
              output << header_color("  #{heading}\n")
              output << send("#{group}_group_color", "#")
              output << "\n"
              output << output_for(group, changes[group])
              output << "\n"
            end
          end
        end

        return output, Gish::OK
      end

      private

      # Dynamically create color methods
      # i.e.: `branch_color`
      COLORS.each do |type, spec|
        define_method "#{type}_color" do |message|
          send(spec.first, message, spec.last)
        end
      end

      # Same as above, but for groups
      GROUPS.each do |group, spec|
        define_method "#{group}_group_color" do |message, options = {}|
          send(spec[:color], message, options)
        end
      end

      def has_modules?
        @has_modules ||= File.exists?(File.join(@project_root, ".gitmodules"))
      end

      def change_string_for(status)
        changes = "#{status.count} changes ("
        staged = status.grep(/\A[^ ?]/).count
        unstaged = status.grep(/\A[ ?]/).count
        changes << "#{staged} staged, #{unstaged} unstaged"
        changes << ")"
      end

      def changes_for(status)
        changes = {
          staged:    [],
          unmerged:  [],
          unstaged:  [],
          untracked: []
        }

        status.each do |raw_change|
          change = { left: raw_change[0], right: raw_change[1], file: raw_change[3..-1] }

          if has_modules? && File.read(File.join(@project_root, ".gitmodules")).include?(change[:file])
            # FIXME: I don't like this...This should be returned instead of the hidden setting of an instance variable
            @long_status = `\git status`
          end

          case raw_change[0..1]
          when "DD"; changes[:unmerged]  << { message: "   both deleted",  color: :deleted,   file: change[:file] }
          when "AU"; changes[:unmerged]  << { message: "    added by us",  color: :added,     file: change[:file] }
          when "UD"; changes[:unmerged]  << { message: "deleted by them",  color: :deleted,   file: change[:file] }
          when "UA"; changes[:unmerged]  << { message: "  added by them",  color: :added,     file: change[:file] }
          when "DU"; changes[:unmerged]  << { message: "  deleted by us",  color: :deleted,   file: change[:file] }
          when "AA"; changes[:unmerged]  << { message: "     both added",  color: :added,     file: change[:file] }
          when "UU"; changes[:unmerged]  << { message: "  both modified",  color: :modified,  file: change[:file] }
          when /M./; changes[:staged]    << { message: "  modified",       color: :modified,  file: change[:file] }
          when /A./; changes[:staged]    << { message: "  new file",       color: :added,     file: change[:file] }
          when /D./; changes[:staged]    << { message: "   deleted",       color: :deleted,   file: change[:file] }
          when /R./; changes[:staged]    << { message: "   renamed",       color: :renamed,   file: change[:file] }
          when /C./; changes[:staged]    << { message: "    copied",       color: :copied,    file: change[:file] }
          when /T./; changes[:staged]    << { message: "typechange",       color: :retyped,   file: change[:file] }
          when "??"; changes[:untracked] << { message: " untracked",       color: :untracked, file: change[:file] }
          end

          if change[:right] == "M"
            changes[:unstaged] << { message: "  modified", color: :modified, file: change[:file] }
          elsif change[:right] == "D" && change[:left] != "D" && change[:left] != "U"
            changes[:unstaged] << { message: "   deleted", color: :deleted, file: change[:file] }
          elsif change[:right] == "T"
            changes[:unstaged] << { message: "typechange", color: :retyped, file: change[:file] }
          end
        end

        changes
      end

      def relative_path(base, target)
        back = ""

        while target.sub(base, "") == target
          base = base.sub(/\/[^\/]*$/, "")
          back = "../#{back}"
        end

        "#{back}#{target.sub("#{base}/","")}"
      end

      def output_for(group, changes)
        output = ""

        changes.each do |change|
          relative_file = relative_path(Dir.pwd, File.join(@project_root, change[:file]))

          submodule_change = nil
          unless @long_status.nil?
            submodule_change = @long_status[/#{change[:file]} \((.*)\)/, 1]

            unless submodule_change.nil?
              submodule_change = "(#{submodule_change})"
            end
          end

          output << send("#{group}_group_color", "#     ")
          output << send("#{change[:color]}_color", change[:message])
          output << ": "
          output << send("#{group}_group_color", relative_file)
          output << " #{submodule_change}\n"
        end

        output << send("#{group}_group_color", "#")
        output
      end
    end
  end
end
