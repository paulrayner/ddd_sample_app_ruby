require 'value_object'

class TestValueObject < DDD::ValueObject
  attr_reader :one
  attr_reader :two

  def initialize(one, two)
    @one = one
    @two = two
  end

end

describe "Testing the ValueObject Base Class" do

  context "Checking attribute handling" do
    subject { TestValueObject.new('a','b') }
    it { should be_a_kind_of(TestValueObject) }
    its(:attributes) { should == {:one => 'a', :two => 'b'}}
    its(:attrs) { should == [:one, :two] }
    its(:data)  { should == ['a', 'b'] }
  end

  context "Checking comparison handling with order" do
    let(:myself)  { TestValueObject.new('a', [1,2,3])}
    let(:match)   { TestValueObject.new(:a.to_s, %w[3 2 1].map{|x|x.to_i})}
    let(:nomatch) { TestValueObject.new('a', [1,2,3,4])}

    specify { (myself == match).should be_false }
    specify { (myself == nomatch).should be_false }

  end

  context "Checking comparison handling without order" do
    let(:myself)  { TestValueObject.new('a', [1,2,3])}
    let(:a_match)   { TestValueObject.new(:a.to_s, %w[3 2 1].map{|x|x.to_i})}
    let(:no_match) { TestValueObject.new('a', [1,2,3,4])}

    specify { (myself.equals a_match, false).should be_true }
    specify { (myself.equals no_match, false).should be_false }
  end


end
