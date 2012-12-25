require 'wreckem/component'

class ContainedBy < Wreckem::Component
  attr_accessor :uuid

  def initialize(uuid)
    super()
    @uuid = uuid
  end
end

