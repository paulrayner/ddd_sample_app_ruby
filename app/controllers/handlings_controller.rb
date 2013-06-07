class HandlingsController < ApplicationController
  def index
    handling_event_repository = HandlingEventRepository.new
    tracking_id = TrackingId.new('cargo_1234')
    @handling_events_history = handling_event_repository.lookup_handling_history_of_cargo(tracking_id)
  end

  def show
    puts "Looking up ", params[:id]
    tracking_id = TrackingId.new(params[:id])
    handling_event_repository = HandlingEventRepository.new
    @handling_events_history = handling_event_repository.lookup_handling_history_of_cargo(tracking_id)
  end

  def create
    event_type = params[:handling][:event_type]
    location_code = params[:handling][:location_code]
    # TODO Lookup location in LocationRepository based on provided location code, for now
    # just use the code
    location = Location.new(UnLocode.new(location_code), location_code)
    # TODO Use dates passed in
    completion_date = DateTime.new(2013, 6, 14) # params[:handling][:completion_date]
    tracking_id = TrackingId.new(params[:handling][:tracking_id])
    register_handling_event = RegisterHandlingEvent.new
    register_handling_event.handle(event_type, location, completion_date, tracking_id)
    redirect_to handlings_path
  end
end
