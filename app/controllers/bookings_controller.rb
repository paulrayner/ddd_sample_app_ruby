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

  def create
  end
end
