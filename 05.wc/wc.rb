#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  process_input(options)
end

def parse_options
  options = { lines: false, words: false, bytes: false }

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

  options_with_defaults(options)
end

def options_with_defaults(options)
  if options.values.none?
    options[:lines] = true
    options[:words] = true
    options[:bytes] = true
  end

  options
end

def count(io)
  counts = { lines: 0, words: 0, bytes: 0 }

  io.each_line do |line|
    counts[:lines] += line.count("\n")
    counts[:words] += line.split.count
    counts[:bytes] += line.bytesize
  end

  counts
end

def process_input(options)
  return process_standard_input(options) if ARGV.empty?

  sum_counts = { lines: 0, words: 0, bytes: 0 }

  ARGV.each do |filename|
    begin
      counts = File.open(filename) do |file|
        count(file)
      end
    rescue Errno::ENOENT
      warn "wc: #{filename}: open: No such file or directory"
      next
    end

    output(counts, options, filename)

    sum_counts[:lines] += counts[:lines]
    sum_counts[:words] += counts[:words]
    sum_counts[:bytes] += counts[:bytes]
  end
  output_total_counts(sum_counts, options)
end

def process_standard_input(options)
  counts = count($stdin)
  output(counts, options)
end

def output_total_counts(sum_counts, options)
  return unless ARGV.size >= 2

  output(sum_counts, options, 'total')
end

def output(counts, options, name = nil)
  show = []
  show << counts[:lines] if options[:lines]
  show << counts[:words] if options[:words]
  show << counts[:bytes] if options[:bytes]

  formatted_counts = show.map { |count| count.to_s.rjust(8) }

  if name
    puts "#{formatted_counts.join('')} #{name}"
  else
    puts formatted_counts.join('')
  end
end

main
