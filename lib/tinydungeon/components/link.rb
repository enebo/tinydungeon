require 'wreckem/component'

class Link < Wreckem::Component
  attr_reader :destination
  attr_reader :directions

  def initialize(directions, destination)
    super()
    @destination, @directions = destination, directions
  end
end

