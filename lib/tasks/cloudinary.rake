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

  task :transform_and_reupload => :environment do |task|

    puts "begin converting all images to jpg, transforming, and reuploading"

    photos = Photo.all
    bar = RakeProgressbar.new(photos.count)

    photos.each do |photo|
      ImageConvertJob.perform_later(photo)
      bar.inc
    end

    bar.finished

  end

end
