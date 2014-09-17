require 'spec_helper'
require 'models_require'

describe RoutingService do
  context "fetch_routes_for_specification()" do
    it "should return no routes if route specification is not met" do
      routing_service = RoutingService.new
      routing_service.fetch_routes_for_specification('something').empty?.should == true
    end
  end
end