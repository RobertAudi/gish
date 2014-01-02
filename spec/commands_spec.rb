require_relative "./spec_helper"
require_relative "../lib/gish/commands"

describe Gish::Commands::BasicCommand do
  before do
    @command = Gish::Commands::BasicCommand.new
  end

  it "has arguments and options" do
    @command.must_respond_to :arguments
    @command.must_respond_to :options
  end

  it "has a dynamic execution method" do
    @command.class.const_defined?(:EXECUTION_METHOD).must_equal true
  end
end
