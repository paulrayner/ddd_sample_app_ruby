require 'ice_nine'
require 'value_object'

class HandlingActivity < ValueObject
  attr_reader :handling_event_type
  attr_reader :location

  def initialize(handling_event_type, location)
    # TODO Check valid values

    @handling_event_type = handling_event_type
    @location = location

    IceNine.deep_freeze(self)
  end
end
