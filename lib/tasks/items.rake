namespace :items do
  task :backfill_original_description => :environment do |task|

    puts "begin backfilling item original descriptions"

    items = Item.where(original_description: nil)
    count = items.count

    bar = RakeProgressbar.new(items.count)

    items.each do |item|
      item.original_description = item.description
      item.save
      bar.inc
    end

    bar.finished

    puts "finished backfilling #{count} items with original descriptions"
  end

  task :reformat_sold_at_dates => :environment do |task|

    puts "begin formatting dates of applicable sold items"

    items = Item.where("sold_at < '#{1.year.ago}'")
    count = items.count

    bar = RakeProgressbar.new(count)

    items.each do |item|
      extracted_original_sale_date = item.sold_at.to_s.split(" ").first.split("-")
      reformatted_sale_date = "#{extracted_original_sale_date[1]}/#{extracted_original_sale_date[0][-2..-1]}/20#{extracted_original_sale_date[2]}"
      item.sold_at = DateTime.strptime(reformatted_sale_date, '%m/%d/%Y')
      item.save
    end

  end

  task :full_inventory_sync => :environment do |task|
    puts "beginning full inventory sync with Clover"
    items = Item.all
    count = items.count

    bar = RakeProgressbar.new(count)

    items.each do |item|
      item.sync_inventory
      bar.inc
    end

    bar.finished

    puts "created async jobs to sync all #{count} items"
  end

  task :backfill_maher_sold_items => :environment do |task|

    proposal = Proposal.find(23)

    item_attrs = [
      {
        description: "Egyptian head wall plaque",
        listing_price_cents: 1000,
        minimum_sale_price_cents: 1000,
        consignment_rate: 0,
        listed_at: DateTime.parse("May 7, 2016"),
        sold_at: DateTime.parse("September 2, 2016"),
        sale_price_cents: 1000,
        client_intention: "consign",
        status: "sold"
      },
      {
        description: "Tan chair",
        listing_price_cents: 5000,
        minimum_sale_price_cents: 5000,
        consignment_rate: 0,
        listed_at: DateTime.parse("July 15, 2016"),
        sold_at: DateTime.parse("September 3, 2016"),
        sale_price_cents: 5000,
        client_intention: "consign",
        status: "sold"
      },
      {
        description: "Floral picture with green matting",
        listing_price_cents: 1300,
        minimum_sale_price_cents: 1300,
        consignment_rate: 0,
        listed_at: DateTime.parse("July 15, 2016"),
        sold_at: DateTime.parse("September 16, 2016"),
        sale_price_cents: 1300,
        client_intention: "consign",
        status: "sold"
      },
      {
        description: "Brass and wood half-moon shelf",
        listing_price_cents: 800,
        minimum_sale_price_cents: 800,
        consignment_rate: 0,
        listed_at: DateTime.parse("July 15, 2016"),
        sold_at: DateTime.parse("September 18, 2016"),
        sale_price_cents: 800,
        client_intention: "consign",
        status: "sold"
      },
      {
        description: "large wood framed mirror",
        listing_price_cents: 15000,
        minimum_sale_price_cents: 15000,
        consignment_rate: 0,
        listed_at: DateTime.parse("July 15, 2016"),
        sold_at: DateTime.parse("September 21, 2016"),
        sale_price_cents: 15000,
        client_intention: "consign",
        status: "sold"
      },
      {
        description: "privacy screen",
        listing_price_cents: 6000,
        minimum_sale_price_cents: 6000,
        consignment_rate: 0,
        listed_at: DateTime.parse("September 29, 2016"),
        sold_at: DateTime.parse("September 30, 2016"),
        sale_price_cents: 6000,
        client_intention: "consign",
        status: "sold"
      },
      {
        description: "Terra cotta bird sculpture",
        listing_price_cents: 700,
        minimum_sale_price_cents: 700,
        consignment_rate: 0,
        listed_at: DateTime.parse("September 29, 2016"),
        sold_at: DateTime.parse("September 30, 2016"),
        sale_price_cents: 700,
        client_intention: "consign",
        status: "sold"
      }
    ]

    item_attrs.each do |item|
      proposal.items.create(item)
    end

  end

  task :tag_expired => :environment do

    items = Item.expired
    bar = RakeProgressbar.new(items.count)
    puts "Begin tagging #{items.count} expired items with 'expired'"

    items.each do |item|
      item.tag_list.add("expired")
      item.save
      bar.inc
    end

    bar.finished
    puts "Tagged #{items.count} items with 'expired'"

  end

end
