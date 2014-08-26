
module MyEnum
  attr_reader :key, :value

  def initialize(key, value)
    @key = key
    @value = value
  end

  def self.included(base)
    base.extend Enumerable
    base.extend ClassMethods
  end

  module ClassMethods
    def define(key, value)
      @_enum_hash ||= {}
      @_enum_hash[key] = new(key, value)
    end

    def const_missing(key)
      if @_enum_hash[key]
        @_enum_hash[key].value
      else
        fail Ruby::Enum::Errors::UninitializedConstantError.new(name: name, key: key)
      end
    end

    def parse(s)
      s = s.to_s.upcase
      each do |key, enum|
        return enum.value if key.to_s.upcase == s
      end
      nil
    end

    def each(&block)
      @_enum_hash.each(&block)
    end
  end
end

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
