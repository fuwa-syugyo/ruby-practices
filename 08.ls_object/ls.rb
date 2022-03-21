#!/usr/bin/env ruby
# frozen_string_literal: true

require './command'

opt = OptionParser.new
params = { long_format: false, reverse: false, dot_match: false }
opt.on('-l') { |v| params[:long_format] = v }
opt.on('-r') { |v| params[:reverse] = v }
opt.on('-a') { |v| params[:dot_match] = v }
opt.parse!(ARGV)

command = Command.new(params)
puts command.run_ls
