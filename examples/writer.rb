require File.dirname(__FILE__) + '/../lib/ttulog'

f = File.open('/tmp/new/00000001-1.ulog', 'w+')
count = 0
TT::Ulog::open('/tmp/new/00000001.ulog') do |record, command|
  count+=1
  record.write(f)
  break if count >= 10
end

f.close
