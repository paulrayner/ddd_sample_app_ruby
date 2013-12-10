require 'spec_helper'
require 'leg'

describe Leg do

  # Has to be a method def instead of the usual RSpec let()
  # because the latter acts more like a variable that persists
  # throught an example no matter how many times you call it
  def random_string
    (0...8).map { (65 + rand(26)).chr }.join
  end

  # This is probably no longer necessary in the final code since
  # it just duplicates the expectations in value_object_spec.rb.
  # I just put it here in the meantime to show that it really works! :-)
  context "#==" do

    it "returns true if all attributes in the equality list are equal" do
      value1 = random_string
      value2 = random_string
      value3 = random_string
      value4 = random_string
      value5 = random_string

      leg1 = Leg.new(value1, value2, value3, value4, value5)
      leg2 = Leg.new(value1, value2, value3, value4, value5)

      (leg1 == leg2).should be_true
    end


    it "returns false if at least one attribute in the equality list doesn't match" do
      value1 = random_string
      value2 = random_string
      value3 = random_string
      value4 = random_string
      value5 = random_string

      leg1 = Leg.new(value1, value2, value3, value4, value5)
      leg2 = Leg.new(value1, value2, value3, value4, value1)

      (leg1 == leg2).should be_false
    end

  end # context #==


end
