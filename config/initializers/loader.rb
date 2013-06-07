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