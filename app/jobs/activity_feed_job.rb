class ActivityFeedJob < ActiveJob::Base
  queue_as :stream

  def perform(object)
    ActivityFeedService.new(object).post
  end

end
