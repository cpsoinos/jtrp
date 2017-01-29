require 'cloudinary/migrator'

namespace :cloudinary do
  task :migrate_images => :environment do |task|

    puts "begin migrating images from S3 to cloudinary"

    photos = Photo.all

    bar = RakeProgressbar.new(photos.count)

    photos.each do |photo|
      Cloudinary::ImageMigrateJob.perform_async(photo)
      bar.inc
    end

    bar.finished

    puts "finished migrating #{photos.count} images"
  end

  task :convert_and_reupload => :environment do |task|

    puts "begin converting all images to jpg"

    photos = Photo.all
    bar = RakeProgressbar.new(photos.count)

    photos.each do |photo|
      Cloudinary::ImageConvertJob.perform_async(photo)
      bar.inc
    end

    bar.finished

  end

  task :delete_derived_resources => :environment do |task|
    Cloudinary::DeleteDerivedResourcesJob.perform_async
  end

end
