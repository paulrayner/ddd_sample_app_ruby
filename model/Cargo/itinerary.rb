require 'ice_nine'
require 'hamster'

class Itinerary
  attr_reader :legs

  # TODO Handle empty values for attributes by returning UNKNOWN location
  # TODO Add is_empty method to supporting checking for this in is_empty

  def initialize(legs)
    # TODO Check valid values

    # @legs = Hamster.list
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
    if (handling_event.event_type == "Receive")
      return legs.first.load_location == handling_event.location
    end
    if (handling_event.event_type == "Unload")
      return legs.any? { |leg| leg.unload_location == handling_event.location }
    end
    if (handling_event.event_type == "Load")
      return legs.any? { |leg| leg.load_location == handling_event.location }
    end
    if (handling_event.event_type == "Claim")
      return legs.last.unload_location == handling_event.location
    end
    false
  end

  def ==(other)
    # TODO Ugly Ruby - must be a better way to compare two arrays for equality of values
    leg_index = 0
    equal = true
    self.legs.each do |leg|
      unless leg == other.legs[leg_index]
        equal = false
      end
      leg_index = leg_index + 1
    end
    equal
  end
end
