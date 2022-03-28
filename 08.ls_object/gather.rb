# frozen_string_literal: true

require 'fileutils'
require_relative 'file_info'

class Gather
  def initialize(params)
    @params = params
  end

  def create_files
    file_all = []
    Dir.foreach('.') do |file|
      next if ['.', '..'].include?(file)
      if @params[:dot_match] 
        file_all << FileInfo.new(file)
      else 
        if File.fnmatch('*', file)
          file_all << FileInfo.new(file)
        end
      end
    end
    file_all.sort! { |a, b| a.basename <=> b.basename}
    file_all.reverse! if @params[:reverse]
    file_all
  end
end
