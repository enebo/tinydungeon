require 'wreckem/component'

class ContainedBy < Wreckem::Component
  attr_accessor :uuid

  def initialize(uuid)
    @uuid = uuid
  end
end

