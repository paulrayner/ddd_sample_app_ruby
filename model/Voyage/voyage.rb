class Voyage
  attr_reader   :id
  attr_accessor :number
  attr_accessor :schedule

  def initialize (number, schedule)
    # TODO: add exception checking for invalid (null) values

    @number = number
    @schedule = schedule
  end

end