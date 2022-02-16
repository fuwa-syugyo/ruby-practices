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
    @frames.sum(&:calc_frame)
  end
end
