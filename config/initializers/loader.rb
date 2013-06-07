puts "Loading domain objects..."
Dir.glob("#{Rails.root.to_s}/domain/**/*.rb").each do |f|
  require f
  # puts f
end

puts "Loading ports and adaptors..."
Dir.glob("#{Rails.root.to_s}/ports/**/*.rb").each do |f|
  require f
  # puts f
end

# TODO Put here for now, but needs to be in a better place
# puts "Subscribing cargo inspection service to registering handling events..."
# register_handling_event = RegisterHandlingEvent.new
# register_handling_event.add_listener(CargoInspectionService.new, :async => true)
