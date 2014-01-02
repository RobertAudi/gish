Dir[File.dirname(File.realpath(__FILE__)) + "/concerns/*.rb"].each do |f|
  require f
end
