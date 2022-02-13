# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def calc_frame
    if first_shot.score == 10 || [first_shot.score, second_shot.score].sum ==10
      [first_shot.score, second_shot.score, third_shot.score].sum
    else
      [first_shot.score, second_shot.score].sum
    end
  end

  def strike?
    @first_shot.score == 10
    # 次の2投の得点追加の処理もここで？
  end

  def spare?
    [first_shot.score, second_shot.score].sum == 10 && first_shot.score != 10
    # 次の1投の得点追加の処理もここで？
  end
end
