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

end
