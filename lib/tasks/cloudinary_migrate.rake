require 'cloudinary/migrator'

namespace :cloudinary do
  task :migrate_images => :environment do |task|

    puts "begin migrating images from S3 to cloudinary"

    photos = Photo.all

    bar = RakeProgressbar.new(photos.count)

    photos.each do |photo|
      ImageMigrateJob.perform_later(photo)
      bar.inc
    end

    bar.finished

    puts "finished migrating #{photos.count} images"
  end

end
