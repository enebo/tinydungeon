require 'wreckem/component'

class Container < Wreckem::Component
  attr_reader :contents

  def initialize
    @contents = []
  end

  def <<(value)
    @contents << value
  end

  def each
    @contents.each { |c| yield c }
  end

  def delete(value)
    @contents.delete(value)
  end
end

