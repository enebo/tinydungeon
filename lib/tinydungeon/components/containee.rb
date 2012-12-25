require 'wreckem/component'

class Containee < Wreckem::Component
  attr_reader :uuid

  def initialize(uuid)
    super()
    @uuid = uuid
  end
end

