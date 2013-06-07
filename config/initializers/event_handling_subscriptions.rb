# TODO Put here for now, but needs to be in a better place
puts "Subscribing cargo inspection service to registering handling events..."
register_handling_event = RegisterHandlingEvent.new
register_handling_event.subscribe(CargoInspectionService.new)