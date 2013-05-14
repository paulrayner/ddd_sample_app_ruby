require 'curator'

class Cargo
  include Curator::Model

  def transport_status
    return false
  end

  attr_accessor :id
  attr_accessor :route_specification
  attr_accessor :itinerary
  attr_accessor :delivery

  def initialize (tracking_id, route_specification)
    # TODO: add exception checking for invalid (null) values

    @tracking_id = tracking_id
    @route_specification = route_specification
    # @delivery = Delivery.derived_from(@route_specification, @itinerary)
  end

  def specify_new_route (route_specification)
    # TODO: add exception checking for invalid (null) values
    @route_specification = route_specification
    # Delivery.update_on_routing(@route_specification, @itinerary)
  end

  def assign_to_route (itinerary)
    # TODO: add exception checking for invalid (null) values
    @itinerary = itinerary
    # Delivery.update_on_routing(@route_specification, @itinerary)
  end

  def derive_delivery_progress (last_handling_event)
    # @delivery = Delivery.derived_from(last_handling_event)
  end
end