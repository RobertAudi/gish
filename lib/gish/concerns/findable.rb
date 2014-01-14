module Gish
  module Concerns
    module Findable
      # IMPROVE: Permit the query to be more complex (e.g.: a regex)
      def fuzzy_find(files, query, options = {})
        return [] if query.empty?

        options[:greedy] ||= false

        eager_pattern = "\\b#{Regexp.escape(query)}"

        if query.include?("/")
          greedy_pattern = query.split("/").map { |p| p.split("").map { |c| Regexp.escape(c) }.join(")[^\/]*?(").prepend("[^\/]*?(") + ")[^\/]*?" }.join("\/")
          greedy_pattern << "\/" if query[-1] == "/"
        else
          greedy_pattern = query.split("").map { |c| Regexp.escape(c) }.join(").*?(").prepend(".*?(") + ").*?"
        end

        eager_results = []
        greedy_results = []
        exact_match_found = false

        files.each do |f|
          if f =~ /#{eager_pattern}/
            eager_results << f
            exact_match_found = true
            next
          end

          if exact_match_found
            next unless options[:greedy]
          end

          greedy_results << f if f =~ /#{greedy_pattern}/
        end

        if eager_results.empty? || options[:greedy]
          eager_results + greedy_results
        else
          eager_results
        end
      end
    end
  end
end
