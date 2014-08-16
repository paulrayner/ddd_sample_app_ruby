require 'ice_nine'
require 'value_object'

class Schedule < ValueObject
  attr_reader :carrier_movements
  attr_reader :departure_time
  attr_reader :arrival_time

  def initialize(carrier_movements, departure_time, arrival_time, price_per_cargo)
    # TODO Check valid values

    @carrier_movements = carrier_movements
    @departure_time = carrier_movements.first.departure_time
    @arrival_time = carrier_movements.last.arrival_time

    IceNine.deep_freeze(self)
  end
end
