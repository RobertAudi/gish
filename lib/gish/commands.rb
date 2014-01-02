module Gish
  module Commands
    class BasicCommand
      EXECUTION_METHOD = :execute!

      attr_reader :arguments, :options
    end
  end
end
