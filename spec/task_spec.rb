require_relative "./spec_helper"
require_relative "../lib/gish/task"

describe Gish::Task do
  before do
    @task = Gish::Task.new
  end

  it "has a command" do
    @task.must_respond_to :command
  end

  it "has options" do
    @task.must_respond_to :options
  end
end
