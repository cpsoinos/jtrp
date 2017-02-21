namespace :webhooks do

  desc "Backfills webhook entries from webhooks"
  task backfill_entries: :environment do

    webhooks = Webhook.all
    puts "Beginning backfilling webhook entries for #{webhooks.count} webhooks..."

    bar = RakeProgressbar.new(webhooks.count)
    created_entries_count = 0

    webhooks.each do |webhook|
      next if webhook.remote_entries.nil?
      webhook.remote_entries.each do |remote_entry|
        WebhookEntry::Creator.new(webhook).create(remote_entry)
        created_entries_count += 1
      end
      bar.inc
    end

    bar.finished
    puts "Backfilled #{created_entries_count} webhook entries for #{webhooks.count} webhooks."
  end

end
