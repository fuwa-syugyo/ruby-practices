# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

OUTPUT_COLUMN_SIZE = 3

class Option
  def initialize
      opt = OptionParser.new
      @params = { long_format: false, reverse: false, dot_match: false }
      opt.on('-l') { |v| @params[:long_format] = v }
      opt.on('-r') { |v| @params[:reverse] = v }
      opt.on('-a') { |v| @params[:dot_match] = v }
      opt.parse!(ARGV)
      create_all_file_array
  end

  def run_ls(long_format: false, reverse: false, dot_match: false)
    dot_or_reverse
    long_format ? ls_long : ls_short
  end

  def create_all_file_array
    @file_all = []
    Dir.foreach('.') do |file|
        next if ['.', '..'].include?(file)
        @file_all << file
        @file_all.sort!
    end
  end

  def dot_or_reverse
    unless @params[:dot_match]
      exclude_hidden_files
    end
    if @params[:reverse]
      dispyay_in_reverse_order
    end
  end

  def ls_short
    @file_all_fix = []

    if (@file_all.size % OUTPUT_COLUMN_SIZE).zero?
      column_size = @file_all.size / OUTPUT_COLUMN_SIZE
    else
      column_size = @file_all.size / OUTPUT_COLUMN_SIZE + 1 # 配列の行と列の個数を揃える
      (column_size * OUTPUT_COLUMN_SIZE - @file_all.size).times do
        @file_all << ' '
      end
    end
    @file_word_count = @file_all.map {|e| e.size }.each_slice(column_size).to_a
    max_word_count = @file_word_count.each {|e| e.fill(e.max)}.flatten
    @file_all.map.with_index do |f, i|
      @file_all_fix << f.ljust(max_word_count[i])
    end
    @file_all_fix.each_slice(column_size).to_a.transpose.map { |e| e.join '  ' }
  end

  def exclude_hidden_files
    @file_all -= @file_all.grep(/^\./)
  end

  def dispyay_in_reverse_order
    @file_all.reverse!
  end

  def ls_long
    @file_all.each_with_index do |file_info, i|
      stat = File.stat(@file_all[i])
      [permission_alphabet(stat), stat.size, Etc.getpwuid(stat.uid).name, Etc.getgrgid(stat.gid).name,
        stat.mtime.strftime('%Y-%m-%d %H:%M'), file_info].join(' ').to_s
    end
  end

  def permission_alphabet(stat)
    mode_alphabet = stat.mode.to_s(8)
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
