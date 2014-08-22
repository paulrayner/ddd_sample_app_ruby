require 'ice_nine'
require 'value_object'

class Itinerary < ValueObject
  attr_reader :legs

  # TODO Handle empty values for attributes by returning UNKNOWN location
  # TODO Add is_empty method to supporting checking for this in is_empty

  def initialize(legs)
    # TODO Check valid values
    @legs = legs.dup

    IceNine.deep_freeze(self)
  end

  def initial_departure_location
    legs.first.load_location
  end

  def final_arrival_location
    legs.last.unload_location
  end

  def final_arrival_date
    legs.last.unload_date
  end

  # Checks whether provided event is expected according to this itinerary specification.
  def is_expected(handling_event)
    if (handling_event.event_type == HandlingEventType::Receive)
      return legs.first.load_location == handling_event.location
    end
    if (handling_event.event_type == HandlingEventType::Unload)
      return legs.any? { |leg| leg.unload_location == handling_event.location }
    end
    if (handling_event.event_type == HandlingEventType::Load)
      return legs.any? { |leg| leg.load_location == handling_event.location }
    end
    if (handling_event.event_type == HandlingEventType::Claim)
      return legs.last.unload_location == handling_event.location
    end
    false
  end
end
