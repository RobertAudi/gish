# TODO: require the stuff below only if the debug mode is ON
require "pp"

module Gish
end

Dir[File.dirname(File.realpath(__FILE__)) + "/gish/*.rb"].each do |f|
  require f
end
