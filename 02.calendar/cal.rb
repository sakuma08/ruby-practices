#! /usr/bin/env ruby

require 'optparse'
require 'date'

params = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}")
month = params["m"].to_i
year = params["y"].to_i

start_date = Date.new(year, month, 1) 
end_date = Date.new(year, month, -1)  
day_of_week = start_date.wday

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
SPACE_PER_DAY = "   "
print SPACE_PER_DAY * day_of_week

(start_date..end_date).each do |date|
  day_str = date.day.to_s.rjust(2)
  if date.saturday?
    puts day_str
  else
    print day_str + " "
  end
end
print "\n"
