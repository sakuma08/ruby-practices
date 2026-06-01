#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = {
  lines: false,
  words: false,
  bytes: false
}

opt = OptionParser.new
opt.on('-l') { options[:lines] = true }
opt.on('-w') { options[:words] = true }
opt.on('-c') { options[:bytes] = true }
begin
  opt.parse!(ARGV)
rescue OptionParser::InvalidOption => e
  name = e.args.first
  warn "wc: illegal option -- #{name.delete_prefix('-')}"
  warn 'usage: wc [-Lclmw] [file ...]'
  exit 1
end

if options.values.none?
  options[:lines] = true
  options[:words] = true
  options[:bytes] = true
end

if ARGV.empty?

  lines = 0
  words = 0
  bytes = 0

  $stdin.each_line do |line|
    lines += line.count("\n")
    words += line.split.count
    bytes += line.bytesize
  end

  counts = []
  counts << lines if options[:lines]
  counts << words if options[:words]
  counts << bytes if options[:bytes]

  formatted_counts = counts.map { |count| count.to_s.rjust(8) }
  puts formatted_counts.join('')

else

  total_lines = 0
  total_words = 0
  total_bytes = 0

  ARGV.each do |filename|
    lines = 0
    words = 0
    bytes = 0

    begin
      File.foreach(filename) do |line|
        lines += line.count("\n")
        words += line.split.count
        bytes += line.bytesize
      end
    rescue Errno::ENOENT
      warn "wc: #{filename}: open: No such file or directory"
      next
    end

    counts = []
    counts << lines if options[:lines]
    counts << words if options[:words]
    counts << bytes if options[:bytes]

    formatted_counts = counts.map { |count| count.to_s.rjust(8) }
    puts "#{formatted_counts.join('')} #{filename}"

    total_lines += lines
    total_words += words
    total_bytes += bytes
  end

  if ARGV.size >= 2
    counts = []
    counts << total_lines if options[:lines]
    counts << total_words if options[:words]
    counts << total_bytes if options[:bytes]

    formatted_counts = counts.map { |count| count.to_s.rjust(8) }
    puts "#{formatted_counts.join('')} total"
  end
end
