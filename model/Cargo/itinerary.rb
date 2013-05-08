require 'ice_nine'
require 'hamster'

class Itinerary
  attr_reader :legs
  attr_reader :initial_departure_location
  attr_reader :final_arrival_location
  attr_reader :final_arrival_date

  # TODO Handle empty values for attributes by returning UNKNOWN location
  # TODO Add is_empty method to supporting checking for this in is_empty

  def initialize(legs)
    # TODO Check valid values

    @legs = Hamster.list(legs)

    IceNine.deep_freeze(self)
  end

  # Checks whether provided event is expected according to this itinerary specification.
  def is_expected(event)

  end

  def ==(other)
    self.legs == other.legs
  end
end
