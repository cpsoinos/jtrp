class CheckImageRetrieverJob < ActiveJob::Base
  queue_as :default

  attr_reader :check

  def perform(options)
    @check = Check.find(options[:check_id])
    retrieve_images
  end

  private

  def retrieve_images
    retrieve_image_front unless check.check_image_front.present?
    retrieve_image_back unless check.check_image_back.present?
    check.save
  end

  def retrieve_image_front
    check.remote_check_image_front_url = check.data["thumbnails"].first["large"]
  end

  def retrieve_image_back
    check.remote_check_image_back_url = check.data["thumbnails"].last["large"]
  end

end
