require 'ice_nine'
require 'hamster'

class HandlingHistory
  attr_reader :handling_events

  # TODO Handle empty values for attributes by returning UNKNOWN location
  # TODO Add is_empty method to supporting checking for this in is_empty

  def initialize(handling_events)
    # TODO Check valid values

    @handling_events = Hamster.list(handling_events)

    IceNine.deep_freeze(self)
  end

  # TODO Implement this (shouldn't it be the default?)
  def events_by_completion_time(event)
    handling_events
  end

  def ==(other)
    # TODO Needs to compare list elements individually
    self.handling_events == other.handling_events
  end
end
