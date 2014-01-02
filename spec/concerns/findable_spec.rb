require_relative "../spec_helper"
require_relative "../../lib/gish/concerns/findable"

describe Gish::Concerns::Findable do
  describe "Inclusion" do
    before do
      @object = Object.new
      @object.class.send(:include, Gish::Concerns::Findable)
    end

    describe "#fuzzy_find" do
      before do
        @files = [
          "config/fish/foo",
          "config/fish/bar"
        ]
      end

      it "fails with no files" do
        [[], nil, "invalid"].each { |files| -> { @object.fuzzy_find(files, "foo") }.must_raise ArgumentError }
      end

      it "returns an array of results" do
        @object.fuzzy_find(@files, "ba").must_be_instance_of Array
      end

      it "prioritises full matches" do
        match =  "config/fish/fii"
        @files << match

        results = @object.fuzzy_find(@files, "fii")
        results.count.must_equal 1
        results.first.must_equal match
      end

      it "falls back to partial matches when there are no full matches" do
        results = @object.fuzzy_find(@files, "fii")
        results.count.must_equal 2
      end

      it "supports greedy fuzzy finding" do
        match =  "config/fish/fii"
        @files << match

        results = @object.fuzzy_find(@files, "fii", greedy: true)
        results.count.must_equal 3
      end
    end
  end
end
