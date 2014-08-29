class BookingsController < ApplicationController
  def index
    cargo_repository = CargoRepository.new
    @cargo_documents = cargo_repository.find_all
  end

  def show
  end

  def create
  end
end
