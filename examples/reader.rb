require File.dirname(__FILE__) + '/../lib/ttulog'

TT::Ulog::open('/tmp/new/00000001.ulog') do |command|
  puts command.inspect
end
