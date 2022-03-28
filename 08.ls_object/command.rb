# frozen_string_literal: true

require_relative 'gather'
require_relative 'display'

class Command
  def initialize(params)
    files = Gather.new(params).create_files
    @display = Display.new(files, params)
    @params = params
  end
end
