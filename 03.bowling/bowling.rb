#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, index|
  break if index >= 9

  point += frame.sum
  next if frame.sum != 10

  point += frames[index + 1][0]

  next unless frame[0] == 10

  point += if frames[index + 1][0] == 10
             frames[index + 2][0]
           else
             frames[index + 1][1]
           end
end

point += frames[9..].flatten.sum
puts point
