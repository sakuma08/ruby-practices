#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COL = 3
COLUMN_SPACING = 1

def main
  options = {}
  opt = OptionParser.new
  opt.on('-l') { options[:long] = true }
  opt.on('-a') { options[:all] = true }
  opt.on('-r') { options[:reverse] = true }
  opt.parse(ARGV)
  names = files(options[:all], options[:reverse])
  if options[:long]
    show_long(names)
  else
    formatted_rows = format_for_show(names)
    show(formatted_rows)
  end
end

def files(show_all, reverse)
  file_names = Dir.glob('*')
  file_names = Dir.glob('*', File::FNM_DOTMATCH) if show_all
  file_names = file_names.reverse if reverse
  file_names
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

def total(names)
  sum = 0
  names.each do |name|
    st = File.lstat(name)
    sum += st.blocks
  end
  puts "total #{sum}"
end

def type_perm(file_stat)
  type = case file_stat.ftype
         when 'file'             then '-'
         when 'directory'        then 'd'
         when 'link'             then 'l'
         when 'characterSpecial' then 'c'
         when 'blockSpecial'     then 'b'
         when 'fifo'             then 'p'
         when 'socket'           then 's'
         else '?'
         end

  mask = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
  perm = 0o777 & file_stat.mode

  owner = (perm >> 6) & 0o7
  group = (perm >> 3) & 0o7
  other = perm & 0o7

  type + mask[owner] + mask[group] + mask[other]
end

def nlink(file_stat)
  file_stat.nlink
end

def uid(file_stat)
  uid = file_stat.uid
  Etc.getpwuid(uid).name
end

def gid(file_stat)
  gid = file_stat.gid
  Etc.getgrgid(gid).name
end

def size(file_stat)
  file_stat.size
end

def mtime(file_stat)
  time = file_stat.mtime
  time.strftime('%_m %e %H:%M')
end

def make_long_row(name)
  file_stat = File.lstat(name)
  [type_perm(file_stat), nlink(file_stat), uid(file_stat), gid(file_stat), size(file_stat), mtime(file_stat), name]
end

def build_long_rows(names)
  names.map do |name|
    row = make_long_row(name)
    row
  end
end

def build_widths(rows)
  widths = [0, 0, 0, 0, 0, 0]

  rows.each do |row|
    row[0..5].each_with_index do |value, i|
      len = value.to_s.length
      widths[i] = len if len > widths[i]
    end
  end

  widths[1] = [widths[1], 2].max
  widths[4] = [widths[4], 5].max
  widths[2] += 1

  widths
end

def show_long(names)
  rows = build_long_rows(names)
  total(names)
  widths = build_widths(rows)

  right_align = [1, 4]

  rows.each do |row|
    cols = row[0..5].each_with_index.map do |v, i|
      s = v.to_s

      if right_align.include?(i)
        s.rjust(widths[i])
      else
        s.ljust(widths[i])
      end
    end
    line = "#{cols.join(' ')} #{row[6]}"
    puts line
  end
end

main if __FILE__ == $PROGRAM_NAME
