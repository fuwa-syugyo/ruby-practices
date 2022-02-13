#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(input)
    @marks = input.split(',')
    create_frames
  end

  def create_frames
    @frames = []

    10.times do
      first_mark, second_mark, third_mark = @marks.slice(0, 3)
      f = Frame.new(first_mark, second_mark, third_mark)
      if f.strike?
        @marks.shift
      else
        @marks.shift(2)
      end
      @frames << f
    end
  end

  def calc_score
    point = 0

    @frames.each do |frame|
      point += frame.calc_frame
    end
    p point
  end
end

game = Game.new(ARGV[0])
game.calc_score
