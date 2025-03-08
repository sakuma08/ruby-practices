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
  next if index >= 10

  if index == 9
    drop_frames = frames.drop(9)
    drop_frames.flatten!
    point += drop_frames.sum
    next
  end

  if (point += frame.sum) && (frame.sum != 10 && frame[0] != 10)
    next # スペアでもストライクでもない場合はスキップ
  end

  if frame.sum == 10 && frame[0] != 10 # スペアの場合
    point += frames[index + 1][0] # 次の1投目を加算する
    next if frame[0] == 10 # ストライクの場合はスキップ
  end
  next unless frame[0] == 10 # ストライクの場合

  if frames[index + 1][0] != 10
    point += frames[index + 1][0] # 次の1投目を加算する
  end
  if frames[index + 1].sum == 10 || frames[index + 1].sum != 10
    point += frames[index + 1][1] # 次の2投目を加算する
  end
  if frames[index + 1][0] == 10
    frames[index + 1][0] == 10 || frames[index + 2][0] == 10
    point += frames[index + 1][0] + frames[index + 2][0] # 次の1投目、2投目を加算する
  end
end
puts point
