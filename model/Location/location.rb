require 'ice_nine'

class Location
  attr_reader :unlocode
  attr_reader :name

  def initialize(unlocode, name)
    @unlocode = unlocode
    @name = name
    
    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.unlocode == other.unlocode
    self.name == other.name
  end

  # TODO Handle unknown location

  def to_s
    @name + " [" + @unlocode + "]"
  end
end