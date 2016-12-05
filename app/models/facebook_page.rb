class FacebookPage < ActiveRecord::Base
  # belongs_to :facebook_account
  has_many :facebook_shares

  validates :name, presence: true
  validates :token, presence: true
  validates :graph_id, presence: true, uniqueness: true
  # validates :facebook_account, presence: true
  validates :page_url, presence: true

  # include FacebookGraphable

  acts_as_paranoid

  def feed
    # @_feed ||= FacebookFeedRetriever.new(self, 5).get_feed
  end

end
