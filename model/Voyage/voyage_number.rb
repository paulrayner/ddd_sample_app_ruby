require 'ice_nine'

class VoyageNumber
  attr_reader :number

  def initialize(number)
    @number = number
    
    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.number == other.number
  end
end
