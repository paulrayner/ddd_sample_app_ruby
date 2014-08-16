require 'ice_nine'
require 'value_object'

class Location < ValueObject
  attr_reader :unlocode
  attr_reader :name

  def initialize(unlocode, name)
    @unlocode = unlocode
    @name = name
    
    IceNine.deep_freeze(self)
  end

  # TODO Handle unknown location

  def to_s
    "#{@name} \[#{@unlocode}]"
  end
end