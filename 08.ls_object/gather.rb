# frozen_string_literal: true

require 'fileutils'

class Gather
  def initialize(params)
    @params = params
  end

  def create_files
    @file_all = []
    Dir.foreach('.') do |file|
      next if ['.', '..'].include?(file)

      @file_all << file
      @file_all.sort!
    end
    dot_or_reverse
    @file_all
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
