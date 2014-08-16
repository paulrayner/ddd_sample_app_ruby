require 'ice_nine'
require 'value_object'

class TransportLeg < ValueObject
  attr_reader :departure_location
  attr_reader :arrival_location

  def initialize(departure_location, arrival_location)
    # TODO Check valid values

    @departure_location = departure_location
    @arrival_location = arrival_location

    IceNine.deep_freeze(self)
  end
end
