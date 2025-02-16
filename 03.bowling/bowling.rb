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
  next unless (0..9).cover?(index)

  point += if index == 9 && frame.sum == 10 && frame[0] != 10 # 10フレーム目で、1投目と2投目が合わせて10点でスペアだった場合
             frame[0] + frame[1] + frames[index + 1][0]
           elsif  index == 9 && frame[0] == 10 && frames[index + 1][0] == 10 # 10フレーム目で、1投目と2投目が両方ともストライクの場合
             frame[0] + frames[index + 1][0] + frames[index + 2][0]
           elsif  index == 9 && frame[0] == 10 && frames[index + 1].sum != 10 # 10フレーム目で、1投目がストライクで、次のフレームがスペアでもストライクでもない場合
             frame[0] + frames[index + 1][0] + frames[index + 1][1]
           elsif frame[0] == 10 && frames[index + 1][0] == 10 && frames[index + 2][0] == 10 # 1投目がストライクで、次の2フレームもストライクだった場合
             frame[0] + frames[index + 1][0] + frames[index + 2][0]
           elsif frame[0] == 10 && frames[index + 1][0] == 10 # 1投目がストライクで、次のフレームもストライクだった場合
             frame[0] + frames[index + 1][0] + frames[index + 2][0]
           elsif frame[0] == 10 && frames[index + 1].sum == 10 # 1投目がストライクで、次のフレームがスペアだった場合
             frame[0] + frames[index + 1][0] + frames[index + 1][1]
           elsif frame[0] == 10 && frames[index + 1].sum != 10 # 1投目がストライクで、次のフレームがスペアでもストライクでもない場合
             frame[0] + frames[index + 1][0] + frames[index + 1][1]
           elsif frame[0] == 10 && frames[index + 1][0] != 10 # 1投目がストライクで、次の1投目がストライクでない場合
             frame[0] + frames[index + 1][0]
           elsif frame.sum == 10 # 1フレームがスペアだった場合
             frame.sum + frames[index + 1][0]
           else # スペアでもストライクでもない場合
             frame.sum
           end
end
puts point
