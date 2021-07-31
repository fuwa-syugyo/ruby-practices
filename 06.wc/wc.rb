#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l')
SPACE_SIZE = 8

line_array = []
elements_array = []
size_array = []
name_array = []

if ARGV.empty?
  inputs = readline(nil)
  ls_array = [inputs.split("\n").size, inputs.split(' ').size,
              inputs.size].map { |n| n.to_s.rjust(SPACE_SIZE) }
  puts ls_array.join

else
  ARGV.each_with_index do |_arg, i|
    f_all = File.open(ARGV[i])
    f_line = File.open(ARGV[i])

    file_all = f_all.read.gsub(/　/, ' ')

    f_line.each_line { |line| line.gsub(/　/, ' ') }

    line_array << f_line.lineno
    elements_array << file_all.split.count
    size_array << File.stat(ARGV[i]).size
    name_array << (ARGV[i])
  end

  if options['l'] == true
    transpose_array = [line_array, name_array].transpose
    rm_name_array = [line_array.sum]
  else
    transpose_array = [line_array, elements_array, size_array, name_array].transpose
    rm_name_array = [line_array.sum, elements_array.sum, size_array.sum]
  end

  transpose_array.each do |x|
    puts x.map { |n| n.to_s.rjust(SPACE_SIZE) }.join(' ')
  end

  if line_array.size > 1
    rm_name_array << 'total'
    puts rm_name_array.map { |n| n.to_s.rjust(SPACE_SIZE) }.join(' ')
  end
end
