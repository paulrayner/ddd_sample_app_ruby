require 'ice_nine'
require 'value_object'

class Location < ValueObject
  attr_reader :unlocode
  attr_reader :name

  CODES = {
    'USCHI' => 'Chicago',
    'USDAL' => 'Dallas',
    'DEHAM' => 'Hamburg',
    'CNHGH' => 'Hangzhou',
    'FIHEL' => 'Helsinki',
    'HKHKG' => 'Hongkong',
    'AUMEL' => 'Melbourne',
    'USLGB' => 'Long Beach',
    'USNYC' => 'New York',
    'NLRTM' => 'Rotterdam',
    'USSEA' => 'Seattle',
    'CNSHA' => 'Shanghai',
    'SESTO' => 'Stockholm',
    'JNTKO' => 'Tokyo'
  }.freeze

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