class CheckImageRetrieverJob < ActiveJob::Base
  queue_as :default
  rescue_from(StandardError) do
    retry_job wait: 10.seconds
  end

  attr_reader :check

  def perform(check)
    @check = check
    retrieve_image_front unless check.check_image_front.present?
    retrieve_image_back unless check.check_image_back.present?
  end

  private

  def retrieve_image_front
    check.remote_check_image_front_url = check.data["thumbnails"].first["large"]
    raise_error unless check.save
  end

  def retrieve_image_back
    check.remote_check_image_back_url = check.data["thumbnails"].last["large"]
    raise_error unless check.save
  end

  def raise_error
    raise StandardError
  end

end
