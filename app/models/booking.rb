class Booking
  include ActiveModel::Validations
  
  attr_accessor :origin, :destination, :arrival_deadline
 
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  validates_presence_of :origin, :destination, :arrival_deadline
  validate :origin_must_not_equal_destination
  validate :arrival_deadline_must_be_in_the_future

  def origin_must_not_equal_destination
    errors.add(:destination, "cannot equal origin") if (self.origin == self.destination)
  end

  def arrival_deadline_must_be_in_the_future
    return if arrival_deadline.blank?
    errors.add(:arrival_deadline, "must be in the future") if Date.parse(arrival_deadline) <= Date.today
  end

  def as_cargo # convert booking to a cargo
    origin_location = Location.new(UnLocode.new(origin), Location::CODES[origin])
    destination_location = Location.new(UnLocode.new(destination), Location::CODES[destination])
    deadline = Date.parse(arrival_deadline)

    route_specification = RouteSpecification.new(origin_location, destination_location, deadline)

    itinerary = Itinerary.new([
      Leg.new('Sharp Shipping', origin_location, deadline-5.days, destination_location, deadline-3.days)
    ])

    cargo = Cargo.new(TrackingId.new("cargo_#{rand(36**6).to_s(36)}"), route_specification)
    cargo.assign_to_route(itinerary)
    cargo
  end

  def to_flash
    "<b>#{Location::CODES[origin]}</b> -> <b>#{Location::CODES[destination]}</b> by <b>#{arrival_deadline}</b>"
  end

  # this is here because of some Rails bug
  def to_key; nil end
end