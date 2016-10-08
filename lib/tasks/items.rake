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

end
