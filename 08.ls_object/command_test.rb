#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'command'
require 'minitest/autorun'

class CommandTest < Minitest::Test
    ## TARGET_PATHNAME = Pathname('./')
  
    def test_run_ls
      command = Command.new(ARGV[0])
      expected = <<~TEXT.chomp
        bin_ls_not_oop.rb  file.rb                    long_option.rb  short_option.rb
        command.rb         lib_ls_command_not_oop.rb  ls_test.rb      test
      TEXT
      assert_equal expected, command.same_lines_columns
    end
  
    # def test_run_ls_long_format
    #   expected = `ls -l #{TARGET_PATHNAME}`.chomp
    #   puts expected
    #   assert_equal expected, run_ls(TARGET_PATHNAME, long_format: true)
    # end
  
    # def test_run_ls_reverse
    #   expected = <<~TEXT.chomp
    #     test             ls_test.rb      lib_ls_command_not_oop.rb  command.rb
    #     short_option.rb  long_option.rb  file.rb                    bin_ls_not_oop.rb
    #   TEXT
    #   assert_equal expected, run_ls(TARGET_PATHNAME, width: 80, reverse: true)
    # end
  
    # def test_run_ls_dot_match
    #   expected = <<~TEXT.chomp
    #     .DS_Store          command.rb                 long_option.rb   test
    #     .gitkeep           file.rb                    ls_test.rb       
    #     bin_ls_not_oop.rb  lib_ls_command_not_oop.rb  short_option.rb  
    #   TEXT
    #   assert_equal expected, run_ls(TARGET_PATHNAME, width: 80, dot_match: true)
    # end
  
    # def test_run_ls_all_options
    #   expected = `ls -lar #{TARGET_PATHNAME}`.chomp
    #   assert_equal expected, run_ls(TARGET_PATHNAME, long_format: true, reverse: true, dot_match: true)
    # end

end
