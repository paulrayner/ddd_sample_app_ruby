require 'ice_nine'

class RouteSpecification
  attr_reader :origin
  attr_reader :destination
  attr_reader :arrival_deadline

  def initialize(origin, destination, arrival_deadline)
    # TODO Check valid values

    @origin = origin
    @destination = destination
    @arrival_deadline = arrival_deadline

    IceNine.deep_freeze(self)
  end

  def is_satisfied_by(itinerary)
    @origin == itinerary.initial_departure_location &&
    @destination == itinerary.final_arrival_location &&
    @arrival_deadline >= itinerary.final_arrival_date
  end

  def ==(other)
    self.origin == other.origin &&
    self.destination == other.destination &&
    self.arrival_deadline == other.arrival_deadline
  end
end
