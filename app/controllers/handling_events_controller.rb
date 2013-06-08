class HandlingEventsController < ApplicationController
  def index
    handling_event_repository = HandlingEventRepository.new
    # TODO this doesn't belong here...obviously!
    tracking_id = TrackingId.new('cargo_1234')
    @handling_events_history = handling_event_repository.lookup_handling_history_of_cargo(tracking_id)
  end

  def show
    tracking_id = TrackingId.new(params[:id])
    handling_event_repository = HandlingEventRepository.new
    @handling_events_history = handling_event_repository.lookup_handling_history_of_cargo(tracking_id)
  end

  def create
    handling_event_registration = HandlingEventRegistration.new
    handling_event_registration.handle(register_handling_event(params))
    redirect_to handling_events_path
  end

  # TODO Create command hash from params - not sure how to do this in one line
  def register_handling_event(params)
    command = Hash.new
    command[:event_type] = params[:handling][:event_type]
    command[:location_code] = params[:handling][:location_code]
    command[:completion_date] = params[:completion_date]
    command[:tracking_id] = params[:handling][:tracking_id]
    command
  end
end
