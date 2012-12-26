require 'wreckem/component'

class Message < Wreckem::Component
  attr_reader :location, :line

  def initialize(location, line)
    super()
    @location, @line = location, line
  end
end

