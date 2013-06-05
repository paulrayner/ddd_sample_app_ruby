require 'delivery'

class DeliveryGenerator
  class << self  # all these methods are class methods

    def generate(route_specification, itinerary, last_handled_event)
      raise Delivery::InitializationError unless route_specification

      last_handled_event = last_handled_event
      last_known_location = calculate_last_known_location(last_handled_event)
      is_unloaded_at_destination = calculate_unloaded_at_destination(last_handled_event, route_specification)
      is_misdirected = calculate_misdirection_status(last_handled_event, itinerary)
      routing_status = calculate_routing_status(itinerary, route_specification)
      transport_status = calculate_transport_status(last_handled_event)
      eta = calculate_eta(itinerary)
      next_expected_activity = calculate_next_expected_activity(last_handled_event, route_specification, itinerary)

      Delivery.new(
        last_handled_event,
        last_known_location,
        is_unloaded_at_destination,
        is_misdirected,
        routing_status,
        transport_status,
        eta,
        next_expected_activity
      )
    end


    # private # helpers to generate the delivery params

    def derived_from(route_specification, itinerary, last_handled_event)
      generate(route_specification, itinerary, last_handled_event)
    end

    def calculate_last_known_location(last_handled_event)
      last_handled_event.location rescue nil
    end

    def calculate_unloaded_at_destination(last_handled_event, route_specification)
      last_handled_event.event_type == "Unload" &&
      last_handled_event.location == route_specification.destination rescue false
    end

    def calculate_misdirection_status(last_handled_event, itinerary)
      !itinerary.is_expected(last_handled_event) rescue false
    end

    def on_track?
      @routing_status == "Routed" && !is_misdirected
    end

    def calculate_routing_status(itinerary, route_specification)
      return nil if itinerary.nil?
      route_specification.is_satisfied_by(itinerary) ? "Routed" : "Misrouted"
    end

    EVENTS = { # these could be moved to Delivery
      "Load" => "Onboard Carrier",
      "Unload" => "In Port",
      "Receive" => "In Port",
      "Claim" => "Claimed",
      "Not Received" => "Not Received"
    }
    def calculate_transport_status(last_handled_event)
      return EVENTS[(last_handled_event.event_type rescue "Not Received")] || "Unknown"
    end

    def calculate_eta(itinerary)
      on_track? ? itinerary.final_arrival_date : nil
    end

    def calculate_next_expected_activity(last_handled_event, route_specification, itinerary)
      return nil unless on_track?
      return HandlingActivity.new("Receive", route_specification.origin) if last_handled_event.nil?

      case last_handled_event.event_type
        when "Receive"
          return HandlingActivity.new("Load", itinerary.legs.first.load_location)
        when "Load"
          last_leg_index = itinerary.legs.index { |x| x.load_location == last_handled_event.location }
          return last_leg_index.nil? == false ? HandlingActivity.new("Unload", itinerary.legs[last_leg_index].unload_location) : nil
        when "Unload"
          itinerary.legs.each_cons(2) do |leg, next_leg|
            if (leg.unload_location == last_handled_event.location)
              return next_leg.nil? ? HandlingActivity.new("Load", leg.load_location) : HandlingActivity.new("Claim", leg.unload_location)
            end
          end
        when "Claim"
          nil # TODO What to do here? .NET doesn't handle this case at all
        else
          nil # TODO What to do here? .NET returns null
      end
    end
  end # class << self

end
