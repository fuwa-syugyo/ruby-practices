# frozen_string_literal: true

require_relative 'file_info'
OUTPUT_COLUMN_SIZE = 3

class Display
  def initialize(files, params)
    @file_all = files
    @params = params
    puts format_option
  end

  def format_option
    @params[:long_format] ? format_long_option : format_short_option
  end

  def format_short_option
    file_name_array = []
    fix_file_name_array = []
    @file_all.each do |file_name|
      file_name_array << file_name.basename
    end

    if (file_name_array.size % OUTPUT_COLUMN_SIZE).zero?
      column_size = file_name_array.size / OUTPUT_COLUMN_SIZE
    else
      column_size = file_name_array.size / OUTPUT_COLUMN_SIZE + 1
      (column_size * OUTPUT_COLUMN_SIZE - file_name_array.size).times do
        file_name_array << ' '
      end
    end

    file_word_count = file_name_array.map(&:size).each_slice(column_size).to_a
    max_word_count = file_word_count.each { |file_info| file_info.fill(file_info.max) }.flatten
    file_name_array.map.with_index do |f, i|
      fix_file_name_array << f.ljust(max_word_count[i])
    end
    fix_file_name_array.each_slice(column_size).to_a.transpose.map { |file_info| file_info.join '  ' }
  end

  def format_long_option
    body = format_long_body
    [*body].join("\n")
  end

  def format_long_body
    @max_sizes = %i[size user group].map do |key|
      find_max_size(key)
    end
    @file_all.map do |file_info|
      format_row(file_info, *@max_sizes)
    end
  end

  def find_max_size(key)
    @file_all.map { |file_info| file_info.to_hash[key].size }.max
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
