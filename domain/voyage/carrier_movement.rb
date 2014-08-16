require 'ice_nine'

class CarrierMovement
  attr_reader :transport_leg
  attr_reader :departure_time
  attr_reader :arrival_time
  attr_reader :price_per_cargo

  def initialize(transport_leg, departure_time, arrival_time, price_per_cargo)
    # TODO Check valid values

    @transport_leg = transport_leg
    @departure_time = departure_time
    @arrival_time = arrival_time
    @price_per_cargo = price_per_cargo

    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.transport_leg == transport_leg &&
    self.departure_time == departure_time &&
    self.arrival_time == arrival_time &&
    self.price_per_cargo == price_per_cargo
  end
end
