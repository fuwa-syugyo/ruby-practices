# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative 'file_info'
require_relative 'before_file_info'

OUTPUT_COLUMN_SIZE = 3

  # やること
  # @file_all_fixを@file_info_arrayに書き換える
  # file_info.rbのメソッドを実装する

class Option
  attr_accessor :file_all

  def initialize
    opt = OptionParser.new
    @params = { long_format: false, reverse: false, dot_match: false }
    opt.on('-l') { |v| @params[:long_format] = v }
    opt.on('-r') { |v| @params[:reverse] = v }
    opt.on('-a') { |v| @params[:dot_match] = v }
    opt.parse!(ARGV)
    create_all_file_array
    @file_all_fix = []
    @file_info_array = []
  end

  def run_ls(long_format: false, reverse: false, dot_match: false)
    @params[:long_format] ? ls_long : ls_short
  end

  def create_all_file_array
    @file_all = []
    Dir.foreach('.') do |file|
      next if ['.', '..'].include?(file)

      @file_all << file
      @file_all.sort!
    end
    dot_or_reverse
  end

  def dot_or_reverse
    exclude_hidden_files unless @params[:dot_match]
    dispyay_in_reverse_order if @params[:reverse]
  end

  def exclude_hidden_files
    @file_all -= @file_all.grep(/^\./)
  end

  def dispyay_in_reverse_order
    @file_all.reverse!
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
    @file_word_count = @file_all.map { |file_info| file_info.size }.each_slice(column_size).to_a
    max_word_count = @file_word_count.each { |file_info| file_info.fill(file_info.max) }.flatten
    @file_all.map.with_index do |f, i|
      @file_all_fix << f.ljust(max_word_count[i])
    end
    @file_all_fix.each_slice(column_size).to_a.transpose.map { |file_info| file_info.join '  ' }
  end

  def ls_long
    @file_all.each do |file_info|
      stat = BeforeFileInfo.new(file_info)
      @file_all_fix << stat.build_data
    end

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
    @file_all_fix.map { |data| data[key].size }.max
  end

  def format_row(file_info, max_size, max_user, max_group)
    [
      "#{file_info.type_and_mode}",
      "  #{file_info.size.to_s.rjust(max_size - 4)}",
      " #{file_info.user.ljust(max_user)}",
      " #{file_info.group.ljust(max_group)}",
      " #{file_info.mtime}",
      " #{file_info.basename}"
    ].join
  end

  def format_mode(mode)
    digits = mode.to_s(8)[-3..-1]
    digits.gsub(/./, MODE_MAP)
  end
end
