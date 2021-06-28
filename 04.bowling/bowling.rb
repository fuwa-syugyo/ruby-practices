#! /usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
shots_actual = [] # ストライクの後に0を入れない、Xではなく10を表示する

scores.each do |shot|
  if shot == 'X' # ストライクの場合、[10,0]とする
    shots << 10
    shots << 0
    shots_actual << 10
  else
    shots << shot.to_i
    shots_actual << shot.to_i
  end
end

frames = []
shots.each_slice(2) do |shot|
  frames << shot
end

point = 0
shots_actual_index = 0 # 実際に投げた得点の順番

frames.each_with_index do |frame, i| # iは繰り返し回数
  next if i >= 10

  if frame[0] == 10 # ストライクの場合、次の2投を加算
    shots_actual_index += 1
    point += frame[0] + shots_actual[shots_actual_index].to_i + shots_actual[shots_actual_index + 1].to_i
  elsif frame.sum == 10 # スペアの場合、次の1投を加算
    shots_actual_index += 2
    point += frame.sum + shots_actual[shots_actual_index].to_i
  elsif i == shots_actual.length - 2 && frame.sum >= 10 # 最後のフレームがストライクorスペアの場合、そのフレームの点のみ加算
    point += frame.sum
  else
    shots_actual_index += 2
    point += frame.sum
  end
end

puts point
