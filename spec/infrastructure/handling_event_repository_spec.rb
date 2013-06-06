require 'spec_helper'
require 'models_require'
require 'handling_event_repository'

describe "HandlingEventRepository" do
  it "Handling event can be persisted" do
    handling_event_repository = HandlingEventRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    handling_event_repository.nuke_all_handling_events

    origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    tracking_id = TrackingId.new('cargo_1234')
    handling_event = HandlingEvent.new("Load", origin, DateTime.new(2013, 6, 14), DateTime.new(2013, 6, 15), tracking_id)

    handling_event_repository.save(handling_event)

    handling_event_history = handling_event_repository.lookup_handling_history_of_cargo(tracking_id)

    handling_event_history.count.should == 1
    handling_event = handling_event_history.first
    handling_event.event_type.should == "Load"
    handling_event.location.should == origin
    handling_event.registration_date.should == DateTime.new(2013, 6, 14)
    handling_event.completion_date.should == DateTime.new(2013, 6, 15)
    handling_event.tracking_id.should == 'cargo_1234'
  end
end