# Inspired by Jamis Buck
# http://weblog.jamisbuck.org/2005/8/7/enumerated-types-in-ruby
class Enum

  class << self
        
    def [](sym)
      raise ArgumentError.new("Unknown element '#{ sym }'") unless const_defined?(sym)
      const_get(sym)
    end


    def const_missing(sym)
      @next_value ||= 0
      const_set(sym, @next_value)
      @next_value += 1
    end

  end

end
