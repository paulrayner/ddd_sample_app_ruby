require 'spec_helper'
require 'models_require'
require 'location_repository'

describe "LocationRepository" do
  it "Location can be stored and then found again by UN/LOCODE" do
    location_repository = LocationRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    location_repository.nuke_all_locations

    location = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    location_repository.store(location)

    found_location = location_repository.find(UnLocode.new('HKG'))
    found_location.should == location
  end

  it "All locations can be found" do
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
    location_repository = LocationRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    location_repository.nuke_all_locations

    locations.each do | code, name |
        location_repository.store(Location.new(UnLocode.new(code), name))
    end

    found_locations = location_repository.find_all()
    found_locations.size.should == 14
    # TODO Add comparing each individual location
  end
end