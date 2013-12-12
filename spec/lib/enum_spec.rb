require 'spec_helper'
require 'enum'

describe Enum do

  let(:enum) do
    Enum.new(:Apples, :Oranges, :Bananas, :Mangoes)
  end


  context '#[](k)' do

    it "accepts an index for getting a member's value" do
      enum[0].should == :Apples
    end


    it "accepts a value for getting a member's index" do
      enum[:Bananas].should == 2
    end

  end

end
