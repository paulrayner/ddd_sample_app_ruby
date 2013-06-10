require 'spec_helper'
require 'models_require'
require 'cargo_repository'
require 'handling_event_repository'
require 'location_repository'


# TODO Massive hack to get sample data into MongoDB
# for manual testing purposes. Remove ASAP.
describe "Sample Data" do
  it "Sample data can be set up" do
    DemoData.new.create_sample_data
    true.should == true
  end
end

class DemoData
  def initialize
  end

  def create_sample_data
    location_repository = LocationRepository.new
    cargo_repository = CargoRepository.new
    handling_event_repository = HandlingEventRepository.new

    # TODO Replace quick-and-dirty data teardown...
    cargo_repository.nuke_all_cargo
    handling_event_repository.nuke_all_handling_events
    location_repository.nuke_all_locations

    # TODO Add missing locations to support these Maersk routes
    # CN:Xingang,CN:Dalian,CN:Qingdao, US:Longbeach, US:Oakland - Maersk Transpacific 8 (eastbound)
    # Taiwan:Kaohsiung, CNHKG, CN:Xiamen, CNSHA, CN:Ningbo, USLGB - Transpacific 2 (eastbound)

    # Transpacific 6 - eastbound
    # Tanjung Pelepas, Malaysia FRI SUN --
    # Ho Chi Minh Ci􏰀 (Vungtau), Vietnam TUE TUE
    # Nansha, Mainland China FRI SAT
    # Yantian, Mainland China SAT SUN
    # Hong Kong, Hong Kong SUN MON
    # Los Angeles, CA, USA SUN THU

    locations = {
                'USCHI' => 'Chicago',
                'USDAL' => 'Dallas',
                'DEHAM' => 'Hamburg',
                'CNHGH' => 'Hangzhou',
                'FIHEL' => 'Helsinki',
                'CNHKG' => 'Hongkong',
                'AUMEL' => 'Melbourne',
                'USLGB' => 'Long Beach',
                'USNYC' => 'New York',
                'NLRTM' => 'Rotterdam',
                'USSEA' => 'Seattle',
                'CNSHA' => 'Shanghai',
                'SESTO' => 'Stockholm',
                'JNTKO' => 'Tokyo'
             }

    locations.each do | code, name |
        location_repository.store(Location.new(UnLocode.new(code), name))
    end

    origin = Location.new(UnLocode.new('CNHKG'), locations['CNHKG'])
    destination = Location.new(UnLocode.new('USDAL'), locations['USDAL'])
    arrival_deadline = DateTime.new(2013, 7, 1)

    route_spec = RouteSpecification.new(origin, destination, arrival_deadline)
    tracking_id = TrackingId.new('cargo_1234')
    port = Location.new(UnLocode.new('USLGB'), locations['USLGB'])
    legs = Array.new
    legs << Leg.new('Voyage ABC', origin, DateTime.new(2013, 6, 14), port, DateTime.new(2013, 6, 19))
    legs << Leg.new('Voyage DEF', port, DateTime.new(2013, 6, 21), destination, DateTime.new(2013, 6, 24))
    itinerary = Itinerary.new(legs)
    cargo = Cargo.new(tracking_id, route_spec)
    cargo.assign_to_route(itinerary)
    cargo_repository.store(cargo)

    handling_event = HandlingEvent.new("Load", origin, DateTime.new(2013, 6, 14), DateTime.new(2013, 6, 15), tracking_id,  HandlingEvent.new_id)
    handling_event_repository.store(handling_event)

    cargo.derive_delivery_progress(handling_event)
    cargo_repository.store(cargo)
  end
end