class HandlingEventRegistration
  include Wisper::Publisher

  def handle(register_handling_event)
    location_repository = LocationRepository.new

    # TODO Make this a conversion to an enum when it is implemented
    event_type = register_handling_event[:event_type]
    registration_date = DateTime.now
    # TODO Convert this to DateTime
    completion_date = DateTime.new(2013, 6, 14) #register_handling_event[:completion_date].to_s
    location = location_repository.find(UnLocode.new(register_handling_event[:location_code]))
    tracking_id = TrackingId.new(register_handling_event[:tracking_id])
    handling_event = HandlingEvent.new(event_type, location, registration_date, completion_date, tracking_id)

    handling_event_repository = HandlingEventRepository.new
    handling_event_repository.store(handling_event)
    puts "Saved new handling event ", handling_event.inspect
    publish(:cargo_was_handled, tracking_id, handling_event)
  end
end