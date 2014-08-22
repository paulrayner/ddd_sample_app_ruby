require 'spec_helper'
require 'models_require'
require 'handling_event_repository'

describe "HandlingEventRepository" do
  it "Handling events can be persisted and retrieved by id" do
    handling_event_repository = HandlingEventRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    handling_event_repository.nuke_all_handling_events

    origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    port = Location.new(UnLocode.new('LGB'), 'Long Beach')
    tracking_id = TrackingId.new('cargo_1234')
    handling_event = HandlingEvent.new(HandlingEventType::Load, origin, DateTime.new(2013, 6, 14), DateTime.new(2013, 6, 15), tracking_id, HandlingEvent.new_id)
    handling_event_repository.store(handling_event)

    found_handling_event = handling_event_repository.find(handling_event.id)

    found_handling_event.id.should == handling_event.id
    found_handling_event.event_type.should == HandlingEventType::Load
    found_handling_event.location.should == origin
    found_handling_event.registration_date.should == DateTime.new(2013, 6, 14)
    found_handling_event.completion_date.should == DateTime.new(2013, 6, 15)
    found_handling_event.tracking_id.should == 'cargo_1234'
  end

  it "Multiple handling events can be persisted and retrieved for a cargo" do
    handling_event_repository = HandlingEventRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    handling_event_repository.nuke_all_handling_events

    origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    port = Location.new(UnLocode.new('LGB'), 'Long Beach')
    tracking_id = TrackingId.new('cargo_1234')
    handling_event1 = HandlingEvent.new(HandlingEventType::Load, origin, DateTime.new(2013, 6, 14), DateTime.new(2013, 6, 15), tracking_id, HandlingEvent.new_id)
    handling_event_repository.store(handling_event1)
    handling_event2 = HandlingEvent.new(HandlingEventType::Unload, port, DateTime.new(2013, 6, 18), DateTime.new(2013, 6, 18), tracking_id, HandlingEvent.new_id)
    handling_event_repository.store(handling_event2)

    handling_event_history = handling_event_repository.lookup_handling_history_of_cargo(tracking_id)

    handling_event_history.count.should == 2

    first_handling_event = handling_event_history[0]
    first_handling_event.id.should == handling_event1.id
    first_handling_event.event_type.should == HandlingEventType::Load
    first_handling_event.location.should == origin
    first_handling_event.registration_date.should == DateTime.new(2013, 6, 14)
    first_handling_event.completion_date.should == DateTime.new(2013, 6, 15)
    first_handling_event.tracking_id.should == 'cargo_1234'

    second_handling_event = handling_event_history[1]
    second_handling_event.id.should == handling_event2.id
    second_handling_event.event_type.should == HandlingEventType::Unload
    second_handling_event.location.should == port
    second_handling_event.registration_date.should == DateTime.new(2013, 6, 18)
    second_handling_event.completion_date.should == DateTime.new(2013, 6, 18)
    second_handling_event.tracking_id.should == 'cargo_1234'
  end
end