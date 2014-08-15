puts "Loading common objects..."
Dir.glob("#{Rails.root.to_s}/lib/*.rb").each do |f|
  require f
end

puts "Loading domain objects..."
Dir.glob("#{Rails.root.to_s}/domain/**/*.rb").each do |f|
  require f
end

puts "Loading ports and adaptors..."
Dir.glob("#{Rails.root.to_s}/ports/**/*.rb").each do |f|
  require f
end

puts "Subscribing cargo inspection service to handling event registrations..."
Wisper::GlobalListeners.add_listener(CargoInspectionService.new, :async => true)
