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

    # TODO Add missing locations to support these Maersk routes
    # CN:Xingang,CN:Dalian,CN:Qingdao, US:Longbeach, US:Oakland - Maersk Transpacific 8 (eastbound)
    # Taiwan:Kaohsiung, HKHKG, CN:Xiamen, CNSHA, CN:Ningbo, USLGB - Transpacific 2 (eastbound)

    # Transpacific 6 - eastbound
    # Tanjung Pelepas, Malaysia FRI SUN --
    # Ho Chi Minh Ci􏰀 (Vungtau), Vietnam TUE TUE
    # Nansha, Mainland China FRI SAT
    # Yantian, Mainland China SAT SUN
    # Hong Kong, Hong Kong SUN MON
    # Los Angeles, CA, USA SUN THU

    @locations = {
                'USCHI' => 'Chicago',
                'USDAL' => 'Dallas',
                'DEHAM' => 'Hamburg',
                'CNHGH' => 'Hangzhou',
                'FIHEL' => 'Helsinki',
                'HKHKG' => 'Hongkong',
                'AUMEL' => 'Melbourne',
                'USLGB' => 'Long Beach',
                'USNYC' => 'New York',
                'NLRTM' => 'Rotterdam',
                'USSEA' => 'Seattle',
                'CNSHA' => 'Shanghai',
                'SESTO' => 'Stockholm',
                'JNTKO' => 'Tokyo'
             }

    @location_repository = LocationRepository.new
    @cargo_repository = CargoRepository.new
    @handling_event_repository = HandlingEventRepository.new

  end

  def create_sample_data
    # TODO Replace quick-and-dirty data teardown...
    @cargo_repository.nuke_all_cargo
    @handling_event_repository.nuke_all_handling_events
    @location_repository.nuke_all_locations

    @locations.each do | code, name |
        @location_repository.store(Location.new(UnLocode.new(code), name))
    end

    # Cargo 1
    cargo_factory(TrackingId.new('cargo_1234'), 'HKHKG', 'USLGB', 'USDAL', DateTime.new(2013, 7, 1))
    # Cargo 2
    cargo_factory(TrackingId.new('cargo_5678'), 'HKHKG', 'USSEA', 'USCHI', DateTime.new(2013, 7, 2))
    # Cargo 3
    cargo_factory(TrackingId.new('cargo_9012'), 'CNSHA', 'USSEA', 'USNYC', DateTime.new(2013, 7, 5))
  end

  def cargo_factory(tracking_id, origin_code, port_code, destination_code, arrival_deadline)
    origin = Location.new(UnLocode.new(origin_code), @locations[origin_code])
    port = Location.new(UnLocode.new(port_code), @locations[port_code])
    destination = Location.new(UnLocode.new(destination_code), @locations[destination_code])
    route_spec = RouteSpecification.new(origin, destination, arrival_deadline)
    cargo = Cargo.new(tracking_id, route_spec)

    legs = Array.new
    legs << Leg.new('Voyage GHI', origin, DateTime.new(2013, 6, 14), port, DateTime.new(2013, 6, 19))
    legs << Leg.new('Voyage JKL', port, DateTime.new(2013, 6, 21), destination, DateTime.new(2013, 6, 24))
    itinerary = Itinerary.new(legs)
    cargo.assign_to_route(itinerary)
    @cargo_repository.store(cargo)

    handling_event = HandlingEvent.new(HandlingEventType::Load, origin, DateTime.new(2013, 6, 14), DateTime.new(2013, 6, 15), tracking_id,  HandlingEvent.new_id)
    @handling_event_repository.store(handling_event)

    cargo.derive_delivery_progress(handling_event)
    @cargo_repository.store(cargo)
  end
end