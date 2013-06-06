class HandlingEvent
  attr_accessor :event_type
  attr_accessor :location
  attr_accessor :registration_date
  attr_accessor :completion_date
  attr_accessor :tracking_id
  # TODO Do we really need this id?
  attr_accessor :id

  def initialize(event_type, location, registration_date, completion_date, tracking_id)
    @event_type = event_type
    @location = location
    @registration_date = registration_date
    @completion_date = completion_date
    @tracking_id = tracking_id
  end
end