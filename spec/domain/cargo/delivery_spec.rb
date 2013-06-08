require 'spec_helper'
require 'delivery'
require 'delivery_generator'

describe Delivery do

  # ===========  initialize  ===========
  context "initialize()" do
    it "should raise an error if route_specification is nil" do
      expect {
        DeliveryGenerator.generate(nil, 'something', 'something')
      }.to raise_error(Delivery::InitializationError)
    end

    it "should not raise an error if last_handled_event is nil" do
      expect {
        DeliveryGenerator.generate(stub.as_null_object, 'something', nil)
      }.to_not raise_error
    end
  end # context initialize()

  # ===========  smoke test value object  ===========
  context "smoke test ValueObject" do
    it "should match when the deliveries match" do
      delivery1 = DeliveryGenerator.generate(stub.as_null_object, 'one', 'one')
      delivery2 = DeliveryGenerator.generate(stub.as_null_object, 'two', 'two')
      (delivery1 == delivery2).should be_false
    end

    it "should not match when the deliveries do not match" do
      delivery1 = DeliveryGenerator.generate(stub.as_null_object, 'one', 'one')
      delivery2 = DeliveryGenerator.generate(stub.as_null_object, 'one', 'one')
      (delivery1 == delivery2).should be_true
    end

  end

end
