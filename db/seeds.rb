# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

company = Company.create(name: "Just the Right Piece", description: "The best second-hand furniture store around")

company.categories.create([{ name: "Bedroom" }, { name: "Dining Room" }, { name: "Living Room" } ])
