require 'wreckem/component'

class CommandLine < Wreckem::Component
  attr_reader :line

  def initialize(line)
    @line = line
  end
end

