require 'date'
require 'ice_nine'

class Delivery
  attr_reader :transport_status
  attr_reader :last_known_location
  attr_reader :is_misdirected
  attr_reader :eta
  attr_reader :is_unloaded_at_destination
  attr_reader :routing_status
  attr_reader :calculated_at
  attr_reader :last_handled_event
  attr_reader :next_expected_activity

  def initialize(route_specification, itinerary, last_handled_event)
    #  TODO What is 'now' for date in Ruby?
    @calculated_at = Date.new(2013, 7, 1)
    @last_handled_event = last_handled_event
    @last_known_location = calculate_last_known_location(last_handled_event)
    @is_unloaded_at_destination = calculate_unloaded_at_destination(last_handled_event, route_specification)
    @is_misdirected = calculate_misdirection_status(last_handled_event, itinerary)
    @routing_status = calculate_routing_status(itinerary, route_specification)
    @transport_status = calculate_transport_status(last_handled_event)
    @eta = calculate_eta(itinerary)
            # _nextExpectedActivity = CalculateNextExpectedActivity(LastEvent, specification, itinerary);
            # _isUnloadedAtDestination = CalculateUnloadedAtDestination(LastEvent, specification);

    IceNine.deep_freeze(self)
  end
  
  def derived_from(route_specification, itinerary, last_handled_event)
    #self(route_specification, itinerary, last_handled_event)
  end

  def calculate_last_known_location(last_handled_event)
    if last_handled_event.nil?
      return nil
    end
    last_handled_event.location
  end

  def calculate_unloaded_at_destination(last_handled_event, route_specification)
    if last_handled_event.nil?
      return false
    end
    last_handled_event.event_type == "Unload" && 
    last_handled_event.location == route_specification.destination
  end

  def calculate_misdirection_status(last_handled_event, itinerary)
    if itinerary.nil?
      return false
    end
    if last_handled_event.nil?
      return false
    end
    itinerary.is_expected(last_handled_event) == false
  end

  def on_track?
    @routing_status == "Routed" && is_misdirected == false
  end

  def calculate_routing_status(itinerary, route_specification)
    if itinerary.nil?
      return nil
    end
    route_specification.is_satisfied_by(itinerary) ? "Routed" : "Misrouted"
  end

  def calculate_transport_status(last_handled_event)
    if last_handled_event.nil?
      return "Not Received"
    end
    case last_handled_event.event_type
      when "Load"
        "Onboard Carrier"
      when "Unload", "Receive"
        "In Port"
      when "Claim"
        "Claimed"
      else
        "Unknown"
      end
  end

  def calculate_eta(itinerary)
    on_track? ? itinerary.final_arrival_date : nil
  end

  def ==(other)
    self.transport_status == transport_status &&
    self.last_known_location == last_known_location &&
    self.is_misdirected == is_misdirected &&
    self.eta == eta &&
    self.is_unloaded_at_destination == is_unloaded_at_destination &&
    self.routing_status == routing_status &&
    self.calculated_at == calculated_at &&
    self.last_handled_event == last_handled_event &&
    self.next_expected_activity == next_expected_activity
  end
end
