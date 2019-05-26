# Users
5.times do |n|
  name = "Admin-#{n+1}"
  email = "admin-#{n+1}@admin.com"
  password = "123456"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    admin: true,
    confirmed_at: Time.zone.now)
end

99.times do |n|
  name = FFaker::Name.name
  email = "user-#{n+1}@user.com"
  password = "123456"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.zone.now)
end

# Location types
names = ["Apartments", "Resorts", "Villas", "Cabins", "Cottages", "Glamping", "Serviced",
  "Vacation Homes", "Guest houses", "Hostels", "Motels", "B&Bs", "Ryokans", "Riads",
  "Resort Villages", "Homestays", "Campgrounds"]
names.each_with_index do |name, index|
  LocationType.create!(name: name,
    pictures: [
        File.open(Rails.root + "vendor/assets/images/seeds/location_type/#{index+1}.jpg")
    ])
end

# Services
names = ["Kitchen", "Shampoo", "Heating", "Air conditioning", "Washer", "Dryer", "Wifi", "Breakfast", "Indoor fireplace", "Hangers", "Iron", "Hair dryer" ,"Laptop friendly workspace", "TV", "Crib", "High chair", "Self check-in", "Smoke detector", "Carbon monoxide detector" ]
names.each do |name|
  Service.create!(name: name)
end

# Locations
users = User.all
3.times do |n|
  users.each do |user|
    name = FFaker::Company.name << " - #{rand(1..100)}"
    address = FFaker::AddressFR.full_address
    national = FFaker::AddressUS.country
    zip_code = FFaker::AddressUS.zip_code
    description = FFaker::Book.description
    location_type_id = LocationType.all.sample.id
    status = true
    user.locations.create!(name: name,
      address: address,
      national: national,
      zip_code: zip_code,
      description: description,
      location_type_id: location_type_id,
      status: true,
      pictures: [
        File.open(Rails.root + "vendor/assets/images/seeds/location/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/location/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/location/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/location/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/location/#{rand 1..12}.jpg")
      ])
  end
end

# Reviews
users = User.all
10.times do |n|
  users.each do |user|
    comment = FFaker::HealthcareIpsum.phrase
    rate = rand(3..5)
    location_id = Location.all.sample.id
    user.reviews.create!(comment: comment,
      rate: rate,
      location_id: location_id)
  end
end

# Bed details
names = ["twin bed", "queen bed", "full bed", "king bed", "bunk bed"]
names.each do |name|
  BedDetail.create!(name: name)
end

# Rooms
locations = Location.all
3.times do |n|
  locations.each do |location|
    name = FFaker::Music.song
    occupancy_limit = rand(4..6)
    living_room = rand(1..2)
    bed_room = rand(1..2)
    bath_room = rand(1..2)
    number_of_bed = rand(1..2)
    quantity = rand(5..10)
    price = rand(50..400)
    bed_detail_id = BedDetail.all.sample.id
    location.rooms.create!(name: name,
      occupancy_limit: occupancy_limit,
      living_room: living_room,
      bed_room: bed_room,
      bath_room: bath_room,
      number_of_bed: number_of_bed,
      quantity: quantity,
      price: price,
      bed_detail_id: bed_detail_id,
      pictures: [
        File.open(Rails.root + "vendor/assets/images/seeds/room/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/room/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/room/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/room/#{rand 1..12}.jpg"),
        File.open(Rails.root + "vendor/assets/images/seeds/room/#{rand 1..12}.jpg")
      ])
  end
end

# Rooms services
rooms = Room.all
rooms.each do |room|
  room.services << Service.order("RAND()").limit(6)
end
