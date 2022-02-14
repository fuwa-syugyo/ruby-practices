#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

game = Game.new(ARGV[0])
game.calc_score
