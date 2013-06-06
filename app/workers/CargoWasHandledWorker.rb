# Invocation in HandlingEventRepository.save(handling_event)
# if @handling_event.save
#   CargoWasHandledWorker.perform_async(@handling_event.tracking_id)
#   redirect_to @handling_event
# ...

class CargoWasHandledWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(tracking_id)
    cargo_repository = CargoRepository.new
    handling_event_repository = HandlingEventRepository.new

    cargo = cargo_repository.find_by_tracking_id(tracking_id)
    handling_history = handling_event_repository.handling_history_of_cargo(tracking_id)
    cargo.derive_delivery_progress(handling_history.last)
    cargo_repository.save(cargo)
  end
end