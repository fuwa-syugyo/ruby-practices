#!/usr/bin/env ruby
# frozen_string_literal: true

require './command'

command = Command.new
puts command.run_ls
