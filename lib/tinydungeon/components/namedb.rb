require 'wreckem/component'

# Tinymud object db.  Names and numbers mapped to uuid.
class NameDB < Wreckem::Component
  attr_reader :name_map # {name => num}
  attr_reader :num_map  # {num => uuid}
  attr_accessor :next_number

  def initialize
    @name_map = {}
    @num_map = {}
    @next_number = 0
  end
end

