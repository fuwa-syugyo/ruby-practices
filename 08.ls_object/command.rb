# frozen_string_literal: true

require 'fileutils'
require_relative 'file_info'
require_relative 'create_file'

OUTPUT_COLUMN_SIZE = 3

class Command
  def initialize(params)
    @create_file = CreateFile.new(params)
    @params = params
    # @file_info_array = []
  end

  def run_ls
    @params[:long_format] ? format_long_option : format_short_option
  end

  def format_short_option
    @create_file.format_short_option
  end

  def format_long_option
    @create_file.format_long_option
  end
end
