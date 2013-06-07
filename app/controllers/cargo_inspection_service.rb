class CargoInspectionService
  include Wisper::Publisher

  def cargo_was_handled(tracking_id, last_handling_event)
    cargo_repository = CargoRepository.new
    cargo = cargo_repository.find_by_tracking_id(tracking_id)
    puts "Old delivery ", cargo.delivery.inspect
    cargo.derive_delivery_progress(last_handling_event)
    puts "New delivery ", cargo.delivery.inspect
    publish(:cargo_is_misdirected, tracking_id) if cargo.delivery.is_misdirected 
    publish(:cargo_is_unloaded_at_destination, tracking_id) if cargo.delivery.is_unloaded_at_destination
    cargo_repository.store(cargo)
  end

  def cargo_is_misdirected(tracking_id)
    puts "Cargo is misdirected - need to reroute it! ", tracking_id.inspect
  end

  def is_unloaded_at_destination(tracking_id)
    puts "Cargo has arrived at the destination - notify the customer.", tracking_id.inspect
  end
end