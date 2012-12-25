require 'wreckem/component'

class Message < Wreckem::Component
  attr_reader :line

  def initialize(line)
    super()
    @line = line
  end
end

