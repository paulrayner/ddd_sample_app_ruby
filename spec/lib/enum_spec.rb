require 'spec_helper'
require 'enum'

describe Enum do


  before(:all) do

    class Fruits < Enum
      Apples
      Oranges
      Bananas
      Mangoes
    end

  end


  context "#[](k)" do

    it "returns the element's index" do
      Fruits[:Bananas].should == 2
    end
    
    
    it "raises an ArgumentError if an invalid name is provided" do
      expect{ Fruits[:Coconut] }.to raise_error(ArgumentError)
    end

  end
  
  
  context "::<Element>" do
    
    it "returns the element's index" do
      Fruits::Mangoes.should == 3
    end    
    
    
    # it "raises a NameError if an invalid name is provided" do
    #   expect{ Fruits::Papaya }.to raise_error(NameError)
    # end
    
  end

end
