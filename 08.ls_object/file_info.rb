# frozen_string_literal: true

require 'etc'

class FileInfo
  def initialize(file_name)
    @stat = File.stat(file_name)
    @file_name = file_name
  end

  MODE_MAP = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '.',
    '12' => 'l',
    '14' => 's',
    '0' => '---',
    '1' => '--x',
    '2' => '-x-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def type_and_mode
    mode_alphabet = @stat.mode.to_s(8)
    mode_alphabet.length == 5 ? mode_alphabet = format('%06d', mode_alphabet) : mode_alphabet

    mode_alphabet_array = mode_alphabet.chars
    mode_alphabet_array[0, 3] = mode_alphabet_array[0..1].join
    make_permission(mode_alphabet_array)
  end

  def make_permission(mode_alphabet_array)
    permission_array = []
    mode_alphabet_array.each do |n|
      permission_array << MODE_MAP[n]
    end
    permission_array.join
  end

  def size
    @stat.size.to_i
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def mtime
    @stat.mtime.strftime('%Y-%m-%d %H:%M')
  end

  def basename
    File.basename(@file_name)
  end

  def to_hash
    {
      type_and_mode: type_and_mode,
      size: size,
      user: user,
      group: group,
      mtime: mtime,
      basename: basename
    }
  end
end
