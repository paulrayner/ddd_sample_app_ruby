require 'curator'
require 'ice_nine'

class Delivery
  include Curator::Model

  attr_reader :transport_status
  attr_reader :last_known_location
  attr_reader :misdirected
  attr_reader :eta
  attr_reader :is_unloaded_at_destination
  attr_reader :routing_status
  attr_reader :calculated_at
  attr_reader :last_event
  attr_reader :next_expected_activity

  def initialize()
    # TODO Fill this in...

    IceNine.deep_freeze(self)
  end

  # TODO Add in all the other methods from .NET example...

  # TODO Implement equality correctly - placeholder method for now...
  def ==(other)
    true
  end
end
