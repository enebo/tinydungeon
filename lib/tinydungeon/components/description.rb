require 'wreckem/component'

class Description < Wreckem::Component
  attr_accessor :value

  def initialize(value)
    super()
    @value = value
  end
end

