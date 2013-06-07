# TODO Put here for now, but needs to be in a better place
Puts "Subscribing cargo inspection service to registering handling events..."
register_handling_event = RegisterHandlingEvent.new
registerHandlingEvent.subscribe(CargoInspectionService.new)