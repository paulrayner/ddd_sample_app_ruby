require 'date'
require 'ice_nine'
require 'pp'
require 'value_object'

class Delivery < DDD::ValueObject
  attr_reader :transport_status
  attr_reader :last_known_location
  attr_reader :is_misdirected
  attr_reader :eta
  attr_reader :is_unloaded_at_destination
  attr_reader :routing_status
  attr_reader :calculated_at
  attr_reader :last_handled_event
  attr_reader :next_expected_activity

  class InitializationError < RuntimeError; end

  def initialize(
    # calculated_at # this is not needed as a param
    last_handled_event,
    last_known_location,
    is_unloaded_at_destination,
    is_misdirected,
    routing_status,
    transport_status,
    eta,
    next_expected_activity)

    @calculated_at = DateTime.now.to_date # just the date part
    @last_handled_event = last_handled_event
    @last_known_location = last_known_location
    @is_unloaded_at_destination = is_unloaded_at_destination
    @is_misdirected = is_misdirected
    @routing_status = routing_status
    @transport_status = transport_status
    @eta = eta
    @next_expected_activity = next_expected_activity

    IceNine.deep_freeze(self)
  end

end
