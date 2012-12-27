require 'wreckem/component'

class LastContainedBy < Wreckem::Component
  attr_accessor :uuid

  def initialize(uuid)
    super()
    @uuid = uuid
  end
end

