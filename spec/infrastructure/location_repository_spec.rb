require 'spec_helper'
require 'models_require'
require 'location_repository'

describe "LocationRepository" do
  it "Location can be stored and then found" do
    location_repository = LocationRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    location_repository.nuke_all_locations

    location = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    location_repository.store(location)

    found_location = location_repository.find(UnLocode.new('HKG'))
    found_location.should == location
  end
end