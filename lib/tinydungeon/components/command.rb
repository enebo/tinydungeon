require 'wreckem/component'

class Command < Wreckem::Component
  attr_reader :line

  def initialize(line)
    @line = line
  end
end

