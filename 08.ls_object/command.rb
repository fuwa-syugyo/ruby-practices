# frozen_string_literal: true

require_relative 'gather'
require_relative 'display'

class Command
  def initialize(params)
    gather = Gather.new(params)
    @display = Display.new(gather.create_files)
    @params = params
  end

  def run_ls
    @params[:long_format] ? format_long_option : format_short_option
  end

  def format_short_option
    @display.format_short_option
  end

  def format_long_option
    @display.format_long_option
  end
end
