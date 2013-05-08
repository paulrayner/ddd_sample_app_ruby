require 'ice_nine'
require 'hamster'

class Leg
  attr_reader :voyage
  attr_reader :load_location
  attr_reader :unload_location
  attr_reader :load_date
  attr_reader :unload_date

  # TODO Handle empty values for attributes by returning UNKNOWN location
  # TODO Add is_empty method to supporting checking for this in is_empty

  def initialize(voyage, load_location, unload_location, load_date, unload_date)
    # TODO Check valid values

    @voyage = voyage
    @load_location = load_location
    @unload_location = unload_location
    @load_date = load_date
    @unload_date = unload_date

    IceNine.deep_freeze(self)
  end

  # Checks whether provided event is expected according to this itinerary specification.
  def is_expected(event)
    # TODO Implement this
  end

  def ==(other)
    self.voyage == voyage &&
    self.load_location == load_location &&
    self.unload_location == unload_location &&
    self.load_date == load_date &&
    self.unload_date == unload_date
  end
end
