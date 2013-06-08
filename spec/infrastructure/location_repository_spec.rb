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

  it "Location can be stored and then found" do

    locations = {
                    'USCHI' => 'Chicago',
                    'USDAL' => 'Dallas',
                    # 'SEGOT' => 'Göteborg',
                    'DEHAM' => 'Hamburg',
                    'CNHGH' => 'Hangzhou',
                    'FIHEL' => 'Helsinki',
                    'CNHKG' => 'Hongkong',
                    'AUMEL' => 'Melbourne',
                    'USNYC' => 'New York',
                    'NLRTM' => 'Rotterdam',
                    'CNSHA' => 'Shanghai',
                    'SESTO' => 'Stockholm',
                    'JNTKO' => 'Tokyo'
                 }
    location_repository = LocationRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    location_repository.nuke_all_locations

    locations.each do | code, name |
        location_repository.store(Location.new(UnLocode.new(code), name))
    end

    found_locations = location_repository.find_all()
    found_locations.size.should == 10
  end
end