# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "***Destroy equipments***"

Equipment.destroy_all

puts "All equipments destroyed !"

puts "***Create Equipments***"

Equipment.create(name: "Wifi", fontawesome_html: '<i class="fa-solid fa-wifi fa-xl"></i>')
puts "Wifi created"

Equipment.create(name: "TV", fontawesome_html: '<i class="fa-solid fa-tv fa-xl"></i>')
puts "TV created"

Equipment.create(name: "Piscine", fontawesome_html: '<i class="fa-sharp fa-solid fa-person-swimming fa-xl"></i>')
puts "Piscine created"

Equipment.create(name: "Parking", fontawesome_html: '<i class="fa-solid fa-square-parking fa-xl"></i>')
puts "Parking created"

Equipment.create(name: "Animaux acceptés", fontawesome_html: '<i class="fa-solid fa-hippo fa-xl"></i>')
puts "Animals created"

puts "All equipments created !"
