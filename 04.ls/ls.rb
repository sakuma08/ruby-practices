#! /usr/bin/env ruby
# frozen_string_literal: true

COL = 3
COLUMN_SPACING = 1

def main
  rows = files
  formatted_rows = format_for_show(rows)
  show(formatted_rows)
end

def files
  Dir.glob('*')
end

def format_for_show(arr)
  row_count = (arr.size.to_f / COL).ceil
  rows = arr.each_slice(row_count).to_a
  remainder = arr.size % COL
  space_count = (COL - remainder) % COL
  space_count.times { rows.last << nil }
  rows.transpose
end

def show(formatted_rows)
  max_length = formatted_rows.flat_map { |row| row.map { |file| file.to_s.length } }.max
  widths = Array.new(COL, max_length)
  formatted_rows.each do |row|
    row.each_with_index do |col, i|
      print col.to_s.ljust(widths[i] + COLUMN_SPACING)
    end
    puts
  end
  puts
end

main if __FILE__ == $PROGRAM_NAME
