# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative 'file_info'

OUTPUT_COLUMN_SIZE = 3

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
    unless @params[:dot_match]
      exclude_hidden_files
    end
    if @params[:reverse]
      dispyay_in_reverse_order
    end
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
      column_size = @file_all.size / OUTPUT_COLUMN_SIZE + 1 # 配列の行と列の個数を揃える
      (column_size * OUTPUT_COLUMN_SIZE - @file_all.size).times do
        @file_all << ' '
      end
    end
    @file_word_count = @file_all.map {|file_info| file_info.size }.each_slice(column_size).to_a
    max_word_count = @file_word_count.each {|file_info| file_info.fill(file_info.max)}.flatten
    @file_all.map.with_index do |f, i|
      @file_all_fix << f.ljust(max_word_count[i])
    end
    @file_all_fix.each_slice(column_size).to_a.transpose.map { |file_info| file_info.join '  ' }
  end

  def ls_long
    @file_all.each do |file_info|
      stat = FileInfo.new(file_info)
      @file_all_fix << stat.build_data
    end

    body = render_long_format_body
    [*body].join("\n")
  end

  def render_long_format_body
    @max_sizes = %i[size user group].map do |key|
    find_max_size(key)
    end
    @file_all_fix.map do |data|
      format_row(data, *@max_sizes)
    end
  end

  def find_max_size(key)
    @file_all_fix.map { |data| data[key].size }.max
  end

  def format_row(data, max_size, max_user, max_group)
    [
      data[:type_and_mode],
      "  #{data[:size].to_s.rjust(max_size - 4)}",
      " #{data[:user].ljust(max_user)}",
      " #{data[:group].ljust(max_group)}",
      " #{data[:mtime]}",
      " #{data[:basename]}"
    ].join
  end
  
  def format_mode(mode)
    digits = mode.to_s(8)[-3..-1]
    digits.gsub(/./, MODE_MAP)
  end
end
