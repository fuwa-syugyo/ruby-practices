#!/usr/bin/env ruby
# frozen_string_literal: true

require './command.rb'

command = Command.new(ARGV[0])
# p command.run_ls(**params)
command.same_lines_columns
