class Cargo
  def transport_status
    return false
  end

  attr_accessor :tracking_id
  attr_accessor :route_specification
  attr_accessor :itinerary
  attr_accessor :delivery

  def initialize (tracking_id, route_specification)
    # TODO: add exception checking for invalid (null) values

    @tracking_id = tracking_id
    @route_specification = route_specification
    @delivery = Delivery.new(@route_specification, @itinerary, nil)
  end

  # cf. https://github.com/SzymonPobiega/DDDSample.Net/blob/master/DDDSample-Vanilla/Domain/Cargo/Cargo.cs#L55
  def specify_new_route (route_specification)
    # TODO: add exception checking for invalid (null) values
    @route_specification = route_specification
    # TODO: Change to @delivery = Delivery.update_on_routing(@route_specification, @itinerary)
    @delivery = Delivery.new(@route_specification, @itinerary, @delivery.last_handling_event)
  end

  # cf. https://github.com/SzymonPobiega/DDDSample.Net/blob/master/DDDSample-Vanilla/Domain/Cargo/Cargo.cs#L69
  def assign_to_route (itinerary)
    # TODO: add exception checking for invalid (null) values
    @itinerary = itinerary
    # TODO: Change to @delivery = Delivery.update_on_routing(@route_specification, @itinerary)
    @delivery = Delivery.new(@route_specification, @itinerary, @delivery.last_handling_event)
  end

  # cf. https://github.com/SzymonPobiega/DDDSample.Net/blob/master/DDDSample-Vanilla/Domain/Cargo/Cargo.cs#L83
  def derive_delivery_progress (last_handling_event)
    # TODO: Change to @delivery = Delivery.derived_from(@route_specification, @itinerary)?
    @delivery = Delivery.new(@route_specification, @itinerary, last_handling_event)
  end
end