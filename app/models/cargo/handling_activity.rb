require 'ice_nine'
require 'hamster'

class HandlingActivity
  attr_reader :handling_event_type
  attr_reader :location

  def initialize(event_type, location)
    # TODO Check valid values

    @handling_event_type = handling_event_type
    @location = location

    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.handling_event_type == other.handling_event_type &&
    self.location == other.location
  end
end
