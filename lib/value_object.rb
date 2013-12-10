class ValueObject

  # Class methods
  class << self

    # @equality_list is a class instance variable that is defined
    # inside the child class. It persists throughout the life of
    # that class.

    def attr_reader(*symbols)
      @equality_list ||= []

      symbols.each do |symbol|
        super(symbol)
        @equality_list << symbol
      end
    end


    def equality_list
      @equality_list.dup
    end

  end


  # Instance methods

  def ==(other)
    if equality_list.empty?
      super(other)
    else
      equality_list.all? do |symbol|
        send(symbol) == other.send(symbol)
      end
    end
  end


  def equality_list
    self.class.equality_list
  end

end
