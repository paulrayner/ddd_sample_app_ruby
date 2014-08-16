require 'ice_nine'
require 'value_object'

class CarrierMovement < ValueObject
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
end
