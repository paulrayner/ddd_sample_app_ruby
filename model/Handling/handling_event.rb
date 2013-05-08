class HandlingEvent
  attr_accessor :cargo
  attr_accessor :event_type
  attr_accessor :location
  attr_accessor :registration_date
  attr_accessor :completion_date
  # TODO Do we really need this id?
  attr_accessor :id

  def initialize(event_type, location, registration_date, completion_date, cargo)
    @event_type = event_type
    @location = location
    @registration_date = registration_date
    @completion_date = completion_date
    @cargo = cargo
  end
end