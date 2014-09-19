require 'ice_nine'
require 'value_object'

# United nations location code.
# 
# http://www.unece.org/cefact/locode/service/location.html
# http://www.unece.org/fileadmin/DAM/cefact/locode/Service/LocodeColumn.htm
#
# Returns a string representation of this UnLocode consisting of 5 characters (all upper):
# 2 chars of ISO country code and 3 describing location.

class UnLocode < ValueObject
  attr_reader :code

  # TODO: Add regex check for valid code

  def initialize(code)
    @code = code
    
    IceNine.deep_freeze(self)
  end

  def to_s
    "#{@code}"
  end
end
