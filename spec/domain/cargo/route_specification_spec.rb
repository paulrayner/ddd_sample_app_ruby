require 'spec_helper'
require 'route_specification'

describe RouteSpecification do

  context "initialize()" do
    {'origin is nil' => [nil, 'something', 'something'],
     'destination is nil' => ['something', nil, 'something'],
     'arrival_deadline is nil' => ['something', 'something', nil],
    }.each do |test, params|
      it "should raise an error if #{test}" do
        expect {
          RouteSpecification.new(*params)
          }.to raise_error(RouteSpecification::InitializationError)
      end
    end # loop

    it "should not raise an error if all three are passed in" do
      expect {
        RouteSpecification.new('x', 'x', 'x')
        }.to_not raise_error
    end
  end # context initialize()



  context "is_satisfied_by()" do
    require 'location'
    require 'itinerary'
    require 'leg'

    before do
      @krakow   = Location.new('PLKRK', 'Krakow')
      @warszawa = Location.new('PLWAW', 'Warszawa')
      @wroclaw  = Location.new('PLWRC', 'Wroclaw')
      @arrival_deadline = Date.new(2011,12,24)
      @route_specification = RouteSpecification.new(@krakow, @wroclaw, @arrival_deadline)
    end

    it "should be satisfied if origin and destination match and arrival deadline not missed" do
      itinerary = Itinerary.new([
        Leg.new(nil, @krakow, Date.new(2011,12,1), @warszawa, Date.new(2011,12,2)),
        Leg.new(nil, @warszawa, Date.new(2011,12,13), @wroclaw, @arrival_deadline)
      ])
      @route_specification.is_satisfied_by(itinerary).should be_true
    end

    it "should not be satisfied if arrival deadline is missed" do
      itinerary = Itinerary.new([
        Leg.new(nil, @krakow, Date.new(2011,12,1), @warszawa, Date.new(2011,12,2)),
        Leg.new(nil, @warszawa, Date.new(2011,12,13), @wroclaw, Date.new(2011,12,25))
      ])
      @route_specification.is_satisfied_by(itinerary).should be_false
    end

    it "should not be satisfied if origin does not match" do
      itinerary = Itinerary.new([
        Leg.new(nil, @warszawa, Date.new(2011,12,13), @wroclaw, Date.new(2011,12,15)),
      ])
      @route_specification.is_satisfied_by(itinerary).should be_false
    end

    it "should not be satisfied if destination does not match" do
      itinerary = Itinerary.new([
        Leg.new(nil, @krakow, Date.new(2011,12,1), @warszawa, Date.new(2011,12,2)),
      ])
      @route_specification.is_satisfied_by(itinerary).should be_false
    end

  end # context is_satisfied_by()

end


