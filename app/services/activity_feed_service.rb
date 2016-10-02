require 'stream'

class ActivityFeedService

  attr_reader :object, :audit

  def initialize(object)
    @object = object
    @audit = object.audits.last
  end

  def post
    feed.add_activity(activity_data)
  end

  private

  def activity_data
    {
      actor: "user:#{user_identifer}",
      verb: audit.action,
      object: "#{audit.auditable_type}:#{audit.auditable_id}",
      time: audit.created_at.iso8601,
      to: ["timeline:jtrp"],
      foreign_id: audit.id
    }
  end

  def user_identifer
    @_user_identifier ||= audit.try(:user_id)
    @_user_identifier ||= "System"
  end

  def feed
    @_feed ||= stream.feed('user', user_identifer)
  end

  def stream
    @_stream ||= Stream::Client.new(ENV['STREAM_KEY'], ENV['STREAM_SECRET'], location: 'us-east')
  end

end
