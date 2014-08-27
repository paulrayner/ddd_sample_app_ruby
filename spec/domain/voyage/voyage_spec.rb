require 'spec_helper'
require 'voyage'

describe Voyage do

  context "entity equality" do
    it "should equal a voyage with the same voyage number" do
      @voyage = Voyage.new('9999', 'fake schedule')
      @voyage.should == Voyage.new('9999', 'another fake schedule')
    end

    it "should not equal a voyage with a different voyage number" do
      @voyage = Voyage.new('9999', 'fake schedule')
      @voyage.should_not == Voyage.new('8888', 'fake schedule')
    end
  end
end