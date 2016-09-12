class AnalyticsTracker

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def identify
    Analytics.identify(
      user_id: user.id,
      traits: {
        name: user.full_name,
        email: user.email,
        created_at: DateTime.now
      }
    )
  end

  def track(event, properties={})
    Analytics.track(
      user_id: user.id,
      event: event,
      properties: properties
    )
  end

end
