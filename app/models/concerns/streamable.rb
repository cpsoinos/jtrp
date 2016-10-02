module Streamable
  extend ActiveSupport::Concern

  included do
    after_save :trigger_stream
  end

  private

  def trigger_stream
    ActivityFeedJob.set(wait: 1.second).perform_later(self)
  end

end
