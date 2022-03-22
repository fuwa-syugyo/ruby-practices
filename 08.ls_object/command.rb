# frozen_string_literal: true

require_relative 'create_file'

class Command
  def initialize(params)
    @create_file = CreateFile.new(params)
    @params = params
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
