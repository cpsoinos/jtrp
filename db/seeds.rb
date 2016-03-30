def create_company
  Company.find_or_create_by!(name: "Just the Right Piece", description: "The best second-hand furniture store around")
end

def create_categories
  Category.create([{ name: "Bedroom" }, { name: "Dining Room" }, { name: "Living Room" } ])
end

create_company
create_categories
