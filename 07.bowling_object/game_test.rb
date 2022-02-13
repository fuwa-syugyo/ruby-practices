# frozen_string_literal: true

require_relative 'game.rb'
require 'minitest/autorun'

class GameTest < Minitest::Test
  def test_calc_final_frame_perfect
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game.calc_score
  end

  def test_calc_spare_or_strike
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.calc_score
  end

#   def test_calc_X_or_10
#     assert_equal 107, calc_score('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
#   end

#   def test_calc_all_zero
#     assert_equal 0, calc_score('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
#   end

#   def test_calc_perfect
#     assert_equal 300, calc_score('X,X,X,X,X,X,X,X,X,X,X,X')
#   end
end
