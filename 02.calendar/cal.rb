#! /usr/bin/env ruby

require 'optparse'
require 'date'

params = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}")
month = params["m"].to_i
year = params["y"].to_i

start_date = Date.new(year,month,1) 
end_date = Date.new(year,month,-1)  
day_of_week = start_date.wday

wdays = ["日 " + "月 " + "火 " + "水 " + "木 " + "金 " + "土 "]

  puts "#{month}月 #{year}".center(20)
  puts wdays
  space_per_day = 3
  print " " * space_per_day * day_of_week

(start_date..end_date).each do |date|

  if date.saturday?
    puts date.day.to_s.rjust(2)  + "\n"
  else
    print date.day.to_s.rjust(2) + " "
  end

end

print "\n"

