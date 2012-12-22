require 'wreckem/component'

class Location < Wreckem::Component
  attr_accessor :uuid

  def initialize(uuid)
    @uuid = uuid
  end
end

