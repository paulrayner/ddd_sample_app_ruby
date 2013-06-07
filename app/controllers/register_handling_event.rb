class RegisterHandlingEvent
#  include Wisper::Publisher

  def handle(event_type, location, completion_date, tracking_id)
    registration_date = DateTime.now
    handling_event = HandlingEvent.new(event_type, location, registration_date, completion_date, tracking_id)

    handling_event_repository = HandlingEventRepository.new
    handling_event_repository.store(handling_event)
#    publish(:cargo_was_handled, tracking_id)
  end
end