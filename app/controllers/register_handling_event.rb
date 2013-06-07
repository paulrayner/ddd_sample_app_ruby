class RegisterHandlingEvent
  include Wisper::Publisher

  def handle(register_handling_event_command)
    # TODO Make this a conversion to an enum when it is implemented
    event_type = register_handling_event_command[:event_type]
    registration_date = DateTime.now
    # TODO Convert this to DateTime
    completion_date = DateTime.new(2013, 6, 14) #register_handling_event_command[:completion_date].to_s
    location_code = register_handling_event_command[:location_code]
    # TODO Look up the location in the LocationRepository based on the code provided
    location = Location.new(UnLocode.new(location_code), location_code)
    tracking_id = TrackingId.new(register_handling_event_command[:tracking_id])
    handling_event = HandlingEvent.new(event_type, location, registration_date, completion_date, tracking_id)

    handling_event_repository = HandlingEventRepository.new
    handling_event_repository.store(handling_event)
    puts "Saved new handling event ", handling_event.inspect
    publish(:cargo_was_handled, tracking_id, handling_event)
  end
end