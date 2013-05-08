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

  # Checks whether provided event is expected according to this itinerary specification.
  def is_expected(event)
    # TODO Implement this
  end

  def ==(other)
    self.legs == other.legs
  end
end
