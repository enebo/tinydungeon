require 'wreckem/component'

class Containing < Wreckem::Component
  attr_reader :uuid

  def initialize(uuid)
    @uuid = uuid
  end
end

