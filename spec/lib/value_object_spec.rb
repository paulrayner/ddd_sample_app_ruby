require 'spec_helper'
require 'value_object'

describe ValueObject do

  # Use an anonymous class to test ValueObject
  let(:klass) do
    Class.new(ValueObject) do
      attr_reader :attr1
      attr_reader :attr2

      def initialize(attr1, attr2)
        @attr1 = attr1
        @attr2 = attr2
      end
    end
  end

  # Has to be a method def instead of the usual RSpec let()
  # because the latter acts more like a variable that persists
  # throught an example no matter how many times you call it
  def random_string
    (0...8).map { (65 + rand(26)).chr }.join
  end


  context "::attr_reader" do

    it "adds a new attribute to the object" do
      value1 = random_string
      value2 = random_string

      obj = klass.new(value1, value2)

      obj.attr1.should == value1
      obj.attr2.should == value2
    end

    it "adds the new attribute to the equality list" do
      klass.send(:equality_list).should == [:attr1, :attr2]
    end


    it "does not share equality lists between child classes" do
      klass2 = Class.new(ValueObject) do
                 attr_reader :klass1_attr1
                 attr_reader :klass2_attr2

                 def initialize(attr1, attr2)
                   @attr1 = attr1
                   @attr2 = attr2
                 end
               end

      klass.send(:equality_list).should_not == klass2.send(:equality_list)
    end

  end # context ::attr_reader


  context "#==" do

    it "returns true if all attributes in the equality list are equal" do
      value1 = random_string
      value2 = random_string

      obj1 = klass.new(value1, value2)
      obj2 = klass.new(value1, value2)

      (obj1 == obj2).should be_true
    end

    it "returns false if at least one attribute in the equality list doesn't match" do
      value1 = random_string
      value2 = random_string

      obj1 = klass.new(value1, value2)
      obj2 = klass.new(value1, value1)

      (obj1 == obj2).should be_false
    end

  end # context #==

end
