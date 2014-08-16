require 'ice_nine'

class TransportLeg
  attr_reader :departure_location
  attr_reader :arrival_location

  def initialize(departure_location, arrival_location)
    # TODO Check valid values

    @departure_location = departure_location
    @arrival_location = arrival_location

    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.departure_location == departure_location &&
    self.arrival_location == arrival_location
  end
end
