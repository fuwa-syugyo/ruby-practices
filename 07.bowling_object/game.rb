#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(_marks)
    input = ARGV[0]
    @marks = input.split(',')
    create_frame(@marks)
  end

  def create_frame(marks)
    shots = []
    @shots_actual = [] # 実際に投げた得点の配列
    frames = []

    marks.each do |mark|
      if strike?(mark) # ストライクの場合、[10,0]とする
        shots << 10
        shots << 0
        @shots_actual << 10
      else
        shots << mark
        @shots_actual << mark
      end
    end

    shots.each_slice(2) do |shot|
      frames << shot
    end
    @frames = frames
  end

  def calc_score
    point = 0
    shots_actual_index = 0 # 実際に投げた得点の順番

    @frames.each_with_index do |frame, i| # iは繰り返し回数
      next if i >= 10

      f = Frame.new(frame[0], frame[1], frame[2])

      if frame[0] == 10 # ストライクの場合、次の2投を加算
        shots_actual_index += 1
        point += frame[0] + @shots_actual[shots_actual_index].to_i + @shots_actual[shots_actual_index + 1].to_i
      elsif f.calc_frame == 10 # スペアの場合、次の1投を加算
        shots_actual_index += 2
        point += f.calc_frame + @shots_actual[shots_actual_index].to_i
      elsif i == @shots_actual.length - 2 && f.calc_frame >= 10 # 最後のフレームがストライクorスペアの場合、そのフレームの点のみ加算
        point += f.calc_frame
      else
        shots_actual_index += 2
        point += f.calc_frame
      end
    end
    puts point
  end
end

def strike?(mark)
  mark == 'X'
end

game = Game.new(@marks)
game.calc_score
