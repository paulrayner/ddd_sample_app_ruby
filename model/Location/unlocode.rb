require 'ice_nine'

# United nations location code.
# 
# http://www.unece.org/cefact/locode/
# http://www.unece.org/cefact/locode/DocColumnDescription.htm#LOCODE
#
# Returns a string representation of this UnLocode consisting of 5 characters (all upper):
# 2 chars of ISO country code and 3 describing location.

class UnLocode
  attr_reader :code

  # TODO: Add regex check for valid code

  def initialize(code)
    @code = code
    
    IceNine.deep_freeze(self)
  end

  def ==(other)
    self.code == other.code
  end

  def to_s
    "#{@code}"
  end
end
