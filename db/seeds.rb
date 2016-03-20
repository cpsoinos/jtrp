company = Company.create(name: "Just the Right Piece", description: "The best second-hand furniture store around")

company.categories.create([{ name: "Bedroom" }, { name: "Dining Room" }, { name: "Living Room" } ])
