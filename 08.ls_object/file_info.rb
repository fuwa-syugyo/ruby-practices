# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require './lib_ls_command_not_oop'

class FileInfo
    def initialize(file_info)
      @stat = File.stat(file_info)
      @file_info = file_info
      @row_data = {
        type_and_mode: permission_alphabet,
        size: @stat.size.to_s,
        user: Etc.getpwuid(@stat.uid).name,
        group: Etc.getgrgid(@stat.gid).name,
        mtime: @stat.mtime.strftime('%Y-%m-%d %H:%M'),
        basename: File.basename(@file_info)
      }
    end

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

    def build_data
      @row_data = {
        type_and_mode: permission_alphabet,
        size: @stat.size.to_i,
        user: Etc.getpwuid(@stat.uid).name,
        group: Etc.getgrgid(@stat.gid).name,
        mtime: @stat.mtime.strftime('%Y-%m-%d %H:%M'),
        basename: File.basename(@file_info)
      }
    end

    def render_long_format_body
      max_sizes = %i[size user group].map do |key|
        find_max_size(key)
      end
      @row_data.map do |data|
        format_row(data, *max_sizes)
      end
    end

    def find_max_size(key)
      @row_data.map { |data| data[key].size }.max
    end

    def format_row(data, max_user, max_group, max_size)
      [
        data[:type_and_mode],
        "  #{data[:size].rjust(max_size)}",
        " #{data[:user].ljust(max_user)}",
        "  #{data[:group].ljust(max_group)}",
        " #{data[:mtime]}",
        " #{data[:basename]}"
      ].join
    end
    
    def format_mode(mode)
      digits = mode.to_s(8)[-3..-1]
      digits.gsub(/./, MODE_MAP)
    end
    
    def permission_alphabet
      mode_alphabet = @stat.mode.to_s(8)
      if mode_alphabet.length == 5
          mode_alphabet = sprintf("%06d", mode_alphabet)
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
end
