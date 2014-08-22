require 'date'
require 'ice_nine'
require 'value_object'
# require 'routing_status'
# require 'transport_status'

class Delivery < ValueObject
  attr_reader :transport_status
  attr_reader :last_known_location
  attr_reader :is_misdirected
  attr_reader :eta
  attr_reader :is_unloaded_at_destination
  attr_reader :routing_status
  attr_reader :calculated_at
  attr_reader :last_handling_event
  attr_reader :next_expected_activity

  class InitializationError < RuntimeError; end

  def initialize(route_specification, itinerary, last_handling_event)
    raise InitializationError unless route_specification

    @last_handling_event = last_handling_event
    @routing_status = calculate_routing_status(itinerary, route_specification)
    @transport_status = calculate_transport_status(last_handling_event)
    @last_known_location = calculate_last_known_location(last_handling_event)
    @is_misdirected = calculate_misdirection_status(last_handling_event, itinerary)
    @is_unloaded_at_destination = calculate_unloaded_at_destination(last_handling_event, route_specification)
    @eta = calculate_eta(itinerary)
    @next_expected_activity = calculate_next_expected_activity(last_handling_event, route_specification, itinerary)
    @calculated_at = DateTime.now

    IceNine.deep_freeze(self)
  end

  def self.derived_from(route_specification, itinerary, last_handling_event)
    Delivery.new(route_specification, itinerary, last_handling_event)
  end

  def on_track?
    @routing_status == RoutingStatus::Routed && is_misdirected == false
  end

  private
  
    def calculate_last_known_location(last_handling_event)
      if last_handling_event.nil?
        return nil
      end
      last_handling_event.location
    end

    def calculate_unloaded_at_destination(last_handling_event, route_specification)
      if last_handling_event.nil?
        return false
      end
      last_handling_event.event_type == HandlingEventType::Unload &&
      last_handling_event.location == route_specification.destination
    end

    def calculate_misdirection_status(last_handling_event, itinerary)
      if itinerary.nil?
        return false
      end
      if last_handling_event.nil?
        return false
      end
      !itinerary.is_expected(last_handling_event)
    end

    def calculate_routing_status(itinerary, route_specification)
      if itinerary.nil?
        return RoutingStatus::NotRouted
      end
      route_specification.is_satisfied_by(itinerary) ? RoutingStatus::Routed : RoutingStatus::Misrouted
    end

    def calculate_transport_status(last_handling_event)
      if last_handling_event.nil?
        return TransportStatus::NotReceived
      end
      case last_handling_event.event_type
        when HandlingEventType::Load
          TransportStatus::OnboardCarrier
        when HandlingEventType::Unload, HandlingEventType::Receive
          TransportStatus::InPort
        when HandlingEventType::Claim
          TransportStatus::Claimed
        else
          TransportStatus::Unknown
        end
    end

    def calculate_eta(itinerary)
      on_track? ? itinerary.final_arrival_date : nil
    end

    def calculate_next_expected_activity(last_handling_event, route_specification, itinerary)
      unless on_track?
        return nil
      end
      if (last_handling_event.nil?)
        return HandlingActivity.new(HandlingEventType::Receive, route_specification.origin)
      end
      case last_handling_event.event_type
        when HandlingEventType::Load
          last_leg_index = itinerary.legs.index { |x| x.load_location == last_handling_event.location }
          return last_leg_index.nil? == false ? HandlingActivity.new(HandlingEventType::Unload, itinerary.legs[last_leg_index].unload_location) : nil
        when HandlingEventType::Unload
          itinerary.legs.each_cons(2) do |leg, next_leg|
            if (leg.unload_location == last_handling_event.location)
              return HandlingActivity.new(HandlingEventType::Load, next_leg.load_location) if next_leg
            end
            return HandlingActivity.new(HandlingEventType::Claim, next_leg.unload_location)
          end
        when HandlingEventType::Receive
          return HandlingActivity.new(HandlingEventType::Load, itinerary.legs.first.load_location)
        when HandlingEventType::Claim
          nil # TODO What to do here? .NET doesn't handle this case at all
        else
          nil # TODO What to do here? .NET returns null
      end
    end

end
