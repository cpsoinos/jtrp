module Trackable
  extend ActiveSupport::Concern

  included do
    has_many :events, as: :object
  end

  def track_creation
    EventCreator.new(self).create("created")
    # AnalyticsTracker.new(self.creator).track("created #{self.class.name.indefinitize}")
  end

  def track_update
    EventCreator.new(self).create("updated")
    # AnalyticsTracker.new(self.updator).track("updated #{self.class.name.indefinitize}")
  end

end
