require_relative "../spec_helper"
require_relative "../../lib/gish/commands.rb"

describe Gish::Commands::AddCommand do
  before do
    @command = Gish::Commands::AddCommand.new
  end

  it "inherits from BasicCommand" do
    Gish::Commands::AddCommand.superclass.must_equal Gish::Commands::BasicCommand
  end

  it "implements the execution method" do
    @command.must_respond_to Gish::Commands::AddCommand::EXECUTION_METHOD
  end
end
