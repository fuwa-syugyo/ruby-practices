# frozen_string_literal: true

require_relative 'gather'
require_relative 'display'

class Command
  def initialize(params)
    files = Gather.new(params).create_files
    @display = Display.new(files)
    @params = params
  end

  def run_ls
    @params[:long_format] ? execution_long_option : execution_short_option
  end

  def execution_short_option
    @display.format_short_option
  end

  def execution_long_option
    @display.format_long_option
  end
end
