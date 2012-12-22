require 'wreckem/component'

class Description < Wreckem::Component
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

