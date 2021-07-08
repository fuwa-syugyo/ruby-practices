#! /usr/bin/env ruby
# frozen_string_literal: true

require 'find'
require 'optparse'
require 'fileutils'
require 'etc'

options = ARGV.getopts('arl')

file_all = []
Dir.foreach('.') do |file|
  next if ['.', '..'].include?(file)

  file_all << file
end
file_all_sort = file_all.sort!

def make_file_type(mode_alphabet_array)
  mode_alphabet_array.each do |n|
    case n
    when '01' then mode_alphabet_array[0] = 'p'
    when '02' then mode_alphabet_array[0] = 'c'
    when '04' then mode_alphabet_array[0] = 'd'
    when '06' then mode_alphabet_array[0] = 'b'
    when '10' then mode_alphabet_array[0] = '.'
    when '12' then mode_alphabet_array[0] = 'l'
    when '14' then mode_alphabet_array[0] = 's'
    end
  end
end

def make_permission(mode_alphabet_array)
  permission_array = [mode_alphabet_array.first]
  mode_alphabet_array.each do |n|
    case n
    when '0' then permission_array << '---'
    when '1' then permission_array << '--x'
    when '2' then permission_array << '-x-'
    when '3' then permission_array << '-wx'
    when '4' then permission_array << 'r--'
    when '5' then permission_array << 'r-x'
    when '6' then permission_array << 'rw-'
    when '7' then permission_array << 'rwx'
    end
  end
  permission_array.join
end

def permission_alphabet(stat)
  mode_alphabet = stat.mode.to_s(8)
  if stat.ftype == 'fifo' || stat.ftype == 'characterSpecial' || stat.ftype == 'directory' || stat.ftype == 'blockSpecial'
    mode_alphabet = "0#{stat.mode.to_s(8)}" # ファイルタイプが一桁のとき頭に0を入れる
  else
    mode_alphabet
  end

  mode_alphabet_array = mode_alphabet.chars
  mode_alphabet_array[0, 3] = mode_alphabet_array[0..1].join
  make_file_type(mode_alphabet_array)
  make_permission(mode_alphabet_array)
end

def option_without_a(file_all_sort)
  hidden_file = file_all_sort.grep(/^\./)
  file_all_sort - hidden_file
end

def option_l(file_all_sort)
  file_all_sort.each_with_index do |file_info, i|
    stat = File.stat(file_all_sort[i])
    puts [permission_alphabet(stat), stat.size, Etc.getpwuid(stat.uid).name, Etc.getgrgid(stat.gid).name,
          stat.mtime.strftime('%Y-%m-%d %H:%M'), file_info].join(' ').to_s
  end
end

def puts_3column(file_all_sort)
  column = 3

  if (file_all_sort.size % column).zero?
    column_size = file_all_sort.size / column
  else
    column_size = file_all_sort.size / column + 1 # 配列の行と列の個数を揃える
    (column_size * column - file_all_sort.size).times do
      file_all_sort << ' '
    end
  end

  puts(file_all_sort.each_slice(column_size).to_a.transpose.map { |e| e.join '  ' })
end

file_all_sort = option_without_a(file_all_sort) if options['a'] == false

def option_r(file_all_sort)
  file_all_sort.reverse!
end

option_r(file_all_sort) if options['r'] == true

if options['l'] == true
  option_l(file_all_sort)
else
  puts_3column(file_all_sort)
end
