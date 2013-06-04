require 'date'
require 'ice_nine'
require 'pp'

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

    @calculated_at = DateTime.now
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

  def ==(other)
    self.transport_status == other.transport_status &&
    self.last_known_location == other.last_known_location &&
    self.is_misdirected == other.is_misdirected &&
    self.eta == other.eta &&
    self.is_unloaded_at_destination == other.is_unloaded_at_destination &&
    self.routing_status == other.routing_status &&
    self.calculated_at == other.calculated_at &&
    self.last_handled_event == other.last_handled_event &&
    self.next_expected_activity == other.next_expected_activity
  end
end
