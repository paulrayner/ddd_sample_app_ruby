class BookingsController < ApplicationController
  def index
    cargo_repository = CargoRepository.new
    @cargo_documents = cargo_repository.find_all
  end

  def show
    tracking_id = TrackingId.new(params[:id])
    cargo_repository = CargoRepository.new
    @cargo = cargo_repository.find_by_tracking_id(tracking_id)
  end

  def new
    @booking = Booking.new
  end


  def create
    @booking = Booking.new(params[:booking])
    if @booking.valid?
      cargo_repository = CargoRepository.new
      cargo_repository.store(@booking.as_cargo)
      redirect_to bookings_path, :notice => "Booking #{@booking.to_flash} was successfully created."
    else
      render :new
    end

  end
end
