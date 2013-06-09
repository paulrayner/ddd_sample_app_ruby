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
  attr_reader :last_handling_event
  attr_reader :next_expected_activity

  class InitializationError < RuntimeError; end

  def initialize(route_specification, itinerary, last_handling_event)
    raise InitializationError unless route_specification

    @last_handling_event = last_handling_event
    @last_known_location = calculate_last_known_location(last_handling_event)
    @transport_status = calculate_transport_status(last_handling_event)
    @is_misdirected = calculate_misdirection_status(last_handling_event, itinerary)
    @is_unloaded_at_destination = calculate_unloaded_at_destination(last_handling_event, route_specification)
    @next_expected_activity = calculate_next_expected_activity(last_handling_event, route_specification, itinerary)
    @eta = calculate_eta(itinerary)
    @routing_status = calculate_routing_status(itinerary, route_specification)
    @calculated_at = DateTime.now

    IceNine.deep_freeze(self)
  end

  def self.derived_from(route_specification, itinerary, last_handling_event)
    Delivery.new(route_specification, itinerary, last_handling_event)
  end

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
    last_handling_event.event_type == "Unload" &&
    last_handling_event.location == route_specification.destination
  end

  def calculate_misdirection_status(last_handling_event, itinerary)
    if itinerary.nil?
      return false
    end
    if last_handling_event.nil?
      return false
    end
    itinerary.is_expected(last_handling_event) == false
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

  def calculate_transport_status(last_handling_event)
    if last_handling_event.nil?
      return "Not Received"
    end
    case last_handling_event.event_type
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

  def calculate_next_expected_activity(last_handling_event, route_specification, itinerary)
    unless on_track?
      return nil
    end
    if (last_handling_event.nil?)
      return HandlingActivity.new("Receive", route_specification.origin)
    end
    case last_handling_event.event_type
      when "Receive"
        return HandlingActivity.new("Load", itinerary.legs.first.load_location)
      when "Load"
        last_leg_index = itinerary.legs.index { |x| x.load_location == last_handling_event.location }
        return last_leg_index.nil? == false ? HandlingActivity.new("Unload", itinerary.legs[last_leg_index].unload_location) : nil
      when "Unload"
        itinerary.legs.each_cons(2) do |leg, next_leg|
          if (leg.unload_location == last_handling_event.location)
            return next_leg.nil? ? HandlingActivity.new("Load", leg.load_location) : HandlingActivity.new("Claim", leg.unload_location)
          end
        end
      when "Claim"
        nil # TODO What to do here? .NET doesn't handle this case at all
      else
        nil # TODO What to do here? .NET returns null
      end
    end

  def ==(other)
    self.transport_status == other.transport_status &&
    self.last_known_location == other.last_known_location &&
    self.is_misdirected == other.is_misdirected &&
    self.eta == other.eta &&
    self.is_unloaded_at_destination == other.is_unloaded_at_destination &&
    self.routing_status == other.routing_status &&
    self.calculated_at == other.calculated_at &&
    self.last_handling_event == other.last_handling_event &&
    self.next_expected_activity == other.next_expected_activity
  end
end
