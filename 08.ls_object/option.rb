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

  def ls_short
    unless @params[:dot_match]
      exclude_hidden_files
    end
    if @params[:reverse]
      dispyay_in_reverse_order
    end

    if (@file_all.size % OUTPUT_COLUMN_SIZE).zero?
      column_size = @file_all.size / OUTPUT_COLUMN_SIZE
    else
      column_size = @file_all.size / OUTPUT_COLUMN_SIZE + 1 # 配列の行と列の個数を揃える
      (column_size * OUTPUT_COLUMN_SIZE - @file_all.size).times do
        @file_all << ' '
      end
    end
    puts @file_all.each_slice(column_size).to_a.transpose.map { |e| e.join '  ' }
  end

  def exclude_hidden_files
    @file_all -= @file_all.grep(/^\./)
  end

  def dispyay_in_reverse_order
    @file_all.reverse!
  end

  def ls_long(file_paths)
    row_data = file_paths.map do |file_path|
      stat = File::Stat.new(file_path)
      build_data(file_path, stat)
    end
    block_total = row_data.sum { |data| data[:blocks] }
    total = "total #{block_total}"
    body = render_long_format_body(row_data)
    [total, *body].join("\n")
  end
end
