# frozen_string_literal: true

require 'fileutils'
require_relative 'file_info'
require_relative 'create_file'

OUTPUT_COLUMN_SIZE = 3

class Command
  def initialize
    create_file = CreateFile.new
    @params = create_file.instance_variable_get(:@params)
    @file_all = create_file.instance_variable_get(:@file_all)
    @file_info_array = []
  end

  def run_ls
    @params[:long_format] ? ls_long : ls_short
  end

  def ls_short
    if (@file_all.size % OUTPUT_COLUMN_SIZE).zero?
      column_size = @file_all.size / OUTPUT_COLUMN_SIZE
    else
      column_size = @file_all.size / OUTPUT_COLUMN_SIZE + 1
      (column_size * OUTPUT_COLUMN_SIZE - @file_all.size).times do
        @file_all << ' '
      end
    end

    @file_word_count = @file_all.map(&:size).each_slice(column_size).to_a
    max_word_count = @file_word_count.each { |file_info| file_info.fill(file_info.max) }.flatten
    @file_all.map.with_index do |f, i|
      @file_info_array << f.ljust(max_word_count[i])
    end
    @file_info_array.each_slice(column_size).to_a.transpose.map { |file_info| file_info.join '  ' }
  end

  def ls_long
    @file_all.each do |file_name|
      file_info = FileInfo.new(file_name)
      @file_info_array << file_info
    end

    body = render_long_format_body
    [*body].join("\n")
  end

  def render_long_format_body
    @max_sizes = %i[size user group].map do |key|
      find_max_size(key)
    end
    @file_info_array.map do |file_info|
      format_row(file_info, *@max_sizes)
    end
  end

  def find_max_size(key)
    @file_info_array.map { |file_info| file_info.build_data[key].size }.max
  end

  def format_row(file_info, max_size, max_user, max_group)
    [
      file_info.type_and_mode.to_s,
      "  #{file_info.size.to_s.rjust(max_size - 4)}",
      " #{file_info.user.ljust(max_user)}",
      " #{file_info.group.ljust(max_group)}",
      " #{file_info.mtime}",
      " #{file_info.basename}"
    ].join
  end

  def format_mode(mode)
    digits = mode.to_s(8)[-3..]
    digits.gsub(/./, MODE_MAP)
  end
end
