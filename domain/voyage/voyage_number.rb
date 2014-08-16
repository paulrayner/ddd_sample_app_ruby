require 'ice_nine'
require 'value_object'

class VoyageNumber < ValueObject
  attr_reader :number

  def initialize(number)
    @number = number
    
    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.number == other.number
  end
end
