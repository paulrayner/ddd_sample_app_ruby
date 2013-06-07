class CargoInspectionService

  def cargo_was_handled(tracking_id, last_handling_event)
    cargo_repository = CargoRepository.new
    cargo = cargo_repository.find_by_tracking_id(tracking_id)
    puts "Found cargo ", cargo.inspect
    puts "Updating based on last handling event ", last_handling_event.inspect
    cargo.derive_delivery_progress(last_handling_event)
    cargo_repository.store(cargo)
  end
end