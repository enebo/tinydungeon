require 'wreckem/component'

class Name < Wreckem::Component
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

