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

  point += frame.sum # フレームを合計する
  next if frame.sum != 10 && frame[0] != 10 # スペアとストライクはスキップ

  if frame.sum == 10 # スペアもしくはストライクの場合
    point += frames[index + 1][0] # 次の1投目を加算する
  end

  break if frame.sum != 10 # スペアの場合は計算を終了させる

  next unless frame[0] == 10 # ストライクでない場合はスキップ

  point += if frames[index + 1][0] == 10 # 次の1フレームもストライクの場合
             frames[index + 2][0] # 次の次のフレームの1投目を加算する
           else
             frames[index + 1][1] # 次の2投目を加算する
           end
end

point += frames[9..].flatten.sum
puts point
