class Enum

  def initialize(*members)
    @members = members
  end


  def [](index_or_value)
    case index_or_value.class.to_s
    when 'Fixnum'
      @members[index_or_value]
    when 'String', 'Symbol'
      @members.index(index_or_value)
    end
  end

end
