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
    @is_misdirected = false

            # _misdirected = CalculateMisdirectionStatus(LastEvent, itinerary);
            # _routingStatus = CalculateRoutingStatus(itinerary, specification);
            # _transportStatus = CalculateTransportStatus(LastEvent);
            # _lastKnownLocation = CalculateLastKnownLocation(LastEvent);
            # _eta = CalculateEta(itinerary);
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

  # TODO Add in all the other methods from .NET example...

  # TODO Implement equality correctly - placeholder method for now...
  def ==(other)
    true
  end
end
