# frozen_string_literal: true

require_relative 'frame'
require 'minitest/autorun'

class FrameTest < Minitest::Test
  def test_normal_frame
    frame = Frame.new('1', '3', '5')
    assert_equal 4, frame.calc_sum_score
  end

  def test_strike_frame
    frame = Frame.new('X', '3', '5')
    assert_equal 18, frame.calc_sum_score
  end

  def test_spare_frame
    frame = Frame.new('6', '4', '5')
    assert_equal 15, frame.calc_sum_score
  end
end
