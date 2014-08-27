class Voyage
  attr_reader   :id       # unique id of this voyage
  attr_accessor :number   # voyage number (non-unique) associated with this voyage
  attr_accessor :schedule # schedule associated with this voyage

  def initialize (number, schedule)
    # TODO: add exception checking for invalid (null) values

    @number = number
    @schedule = schedule
  end

  def ==(other)
    self.number == other.number
  end
end