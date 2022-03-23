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
    run_short_option
    @file_all
  end

  def run_short_option
    @file_all -= @file_all.grep(/^\./) unless @params[:dot_match]
    @file_all.reverse! if @params[:reverse]
  end
end
