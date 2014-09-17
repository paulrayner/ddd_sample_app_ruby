puts "Loading common objects..."
Dir.glob("#{Rails.root.to_s}/lib/*.rb").each do |f|
  puts "Loading: " + f
  require f
end

puts "Loading domain objects..."
Dir.glob("#{Rails.root.to_s}/domain/**/*.rb").each do |f|
  puts "Loading: " + f
  require f
end

puts "Loading services..."
Dir.glob("#{Rails.root.to_s}/services/**/*.rb").each do |f|
  puts "Loading: " + f
  require f
end

puts "Loading ports and adaptors..."
Dir.glob("#{Rails.root.to_s}/ports/**/*.rb").each do |f|
  puts "Loading: " + f
  require f
end

puts "Loading models..."
Dir.glob("#{Rails.root.to_s}/app/models/**/*.rb").each do |f|
  puts "Loading: " + f
  require f
end


puts "Subscribing cargo inspection service to handling event registrations..."
Wisper::GlobalListeners.add_listener(CargoInspectionService.new, :async => true)
