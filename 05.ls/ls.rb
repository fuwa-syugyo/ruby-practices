#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

OUTPUT_COLUMN_SIZE = 3
MODE_MAP = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '.',
  '12' => 'l',
  '14' => 's',
  '0' => '---',
  '1' => '--x',
  '2' => '-x-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  file_all = []
  options = ARGV.getopts('arl')
  Dir.foreach('.') do |file|
    next if ['.', '..'].include?(file)

    file_all << file
  end
  file_all_sort = file_all.sort!

  file_all_sort = exclude_hidden_files(file_all_sort) if options['a'] == false

  option_r(file_all_sort) if options['r'] == true

  if options['l'] == true
    option_l(file_all_sort)
  else
    same_lines_columns(file_all_sort)
  end
end

def exclude_hidden_files(file_all_sort)
  hidden_file = file_all_sort.grep(/^\./)
  file_all_sort - hidden_file
end

def option_r(file_all_sort)
  file_all_sort.reverse!
end

def same_lines_columns(file_all_sort)
  if (file_all_sort.size % OUTPUT_COLUMN_SIZE).zero?
    column_size = file_all_sort.size / OUTPUT_COLUMN_SIZE
  else
    column_size = file_all_sort.size / OUTPUT_COLUMN_SIZE + 1 # 配列の行と列の個数を揃える
    (column_size * OUTPUT_COLUMN_SIZE - file_all_sort.size).times do
      file_all_sort << ' '
    end
  end

  puts(file_all_sort.each_slice(column_size).to_a.transpose.map { |e| e.join '  ' })
end

def option_l(file_all_sort)
  file_all_sort.each_with_index do |file_info, i|
    stat = File.stat(file_all_sort[i])
    puts [permission_alphabet(stat), stat.size, Etc.getpwuid(stat.uid).name, Etc.getgrgid(stat.gid).name,
          stat.mtime.strftime('%Y-%m-%d %H:%M'), file_info].join(' ').to_s
  end
end

def permission_alphabet(stat)
  mode_alphabet = stat.mode.to_s(8)
  if stat.ftype == 'fifo' || stat.ftype == 'characterSpecial' || stat.ftype == 'directory' || stat.ftype == 'blockSpecial'
    mode_alphabet = "0#{stat.mode.to_s(8)}"
  else
    mode_alphabet
  end

  mode_alphabet_array = mode_alphabet.chars
  mode_alphabet_array[0, 3] = mode_alphabet_array[0..1].join
  make_permission(mode_alphabet_array)
end

def make_permission(mode_alphabet_array)
  permission_array = []
  mode_alphabet_array.each do |n|
    permission_array << MODE_MAP[n]
  end
  permission_array.join
end

main
