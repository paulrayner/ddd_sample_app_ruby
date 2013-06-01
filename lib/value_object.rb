module DDD
  class ValueObject

    def attributes # {:one => '1', :two => '2'}
      Hash[instance_variables.map{|ivar| [ivar.to_s.gsub('@','').to_sym,instance_variable_get(ivar)]}]
    end

    def attrs # [:one, :two]
      attributes.keys
    end

    def data # ['1', '2']
      attributes.values
    end

    def ==(other, order_matters=true) equals(other, order_matters); end # alias doesn't work

    # ValueObject1 == ValueObject2 IFF all attrs equal
    def equals(other, order_matters=true) # walk through the attributes and compare them
      attrs.all? do |attr_method|
        self_value = self.send(attr_method)
        other_value = other.send(attr_method)
        if order_matters || self_value.class != Array
          self_value == other_value
        else # see: http://stackoverflow.com/questions/9095017/comparing-two-arrays-in-ruby
          (self_value.size == other_value.size) && (self_value & other_value == self_value)
        end
      end
    end
  end
end

