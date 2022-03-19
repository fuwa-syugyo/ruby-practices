# frozen_string_literal: true

require 'optparse'

class CreateFile
  def initialize
    opt = OptionParser.new
    @params = { long_format: false, reverse: false, dot_match: false }
    opt.on('-l') { |v| @params[:long_format] = v }
    opt.on('-r') { |v| @params[:reverse] = v }
    opt.on('-a') { |v| @params[:dot_match] = v }
    opt.parse!(ARGV)
    @file_info_array = []
    create_files
  end

  def create_files
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
end
