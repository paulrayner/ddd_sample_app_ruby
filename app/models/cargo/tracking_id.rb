require 'ice_nine'

class TrackingId
  attr_reader :id

  def initialize(id)
    @id = id
    
    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.id == other.id
  end
end
