require 'ice_nine'
require 'value_object'

class TrackingId < ValueObject
  attr_reader :id

  def initialize(id)
    @id = id
    
    IceNine.deep_freeze(self)
  end
end
