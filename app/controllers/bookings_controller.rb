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



  # def store(cargo)
  #   # TODO Figure out how to update existing document
  #   # when the delivery progress is updated, rather than
  #   # create a new one.
  #   cargo_doc = CargoDocument.where(tracking_id: cargo.tracking_id.id)
  #   if cargo_doc
  #     puts "Cargo already saved...removing existing document..."
  #     cargo_doc.delete
  #   end
  #   cargo_document = CargoDocumentAdaptor.new.transform_to_mongoid_document(cargo)
  #   # Upsert didn't work. Change back to save?
  #   cargo_document.save
  # end

  # 