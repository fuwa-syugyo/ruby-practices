#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l')

line_array = []
elements_array = []
size_array = []
name_array = []

if ARGV.empty?
  inputs = readlines.map { |input| input.split(' ') }
  byte_size = inputs.map { |e| e.join ' ' }
  ls_array = [inputs.size, inputs.join(' ').split(' ').count, byte_size.to_s.bytesize]
  puts "      #{ls_array.join('      ')}"
else
  ARGV.each_with_index do |_arg, i|
    f_all = File.open(ARGV[i])
    f_line = File.open(ARGV[i])

    file_all = f_all.read
    file_all = file_all.gsub(/　/, ' ')

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
    puts "      #{x.join('     ')}"
  end

  if line_array.size > 1
    rm_name_array << 'total'
    rm_name_array.map!(&:to_s)
    puts "      #{rm_name_array.join('     ')}"
  end
end
