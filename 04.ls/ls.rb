#! /usr/bin/env ruby
# frozen_string_literal: true

COL = 3

def main
  rows = files
  rows = sorted_numbers(rows)
  show(rows)
end

def files
  Dir.glob('*')
end

def sorted_numbers(arr)
  row_count = (arr.size.to_f / COL).ceil
  rows = arr.each_slice(row_count).to_a
  remainder = arr.size % COL
  space_count = (COL - remainder) % COL
  space_count.times { rows.last << ' ' }
  rows.transpose
end

def show(rows)
  rows.each do |row|
    row.each do |col|
      print col.ljust(13)
    end
    puts
  end
  puts
end

main if __FILE__ == $PROGRAM_NAME
