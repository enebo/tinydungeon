require 'wreckem/component'

class CommandLine < Wreckem::Component
  attr_reader :line

  def initialize(line)
    super()
    @line = line
  end
end

