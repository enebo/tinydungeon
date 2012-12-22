require 'wreckem/component'

class Link < Wreckem::Component
  attr_reader :destination
  attr_reader :directions

  def initialize(directions, destination)
    @destination, @directions = destination, directions
  end
end

