class FacebookAccount < ActiveRecord::Base
  belongs_to :identity
  # has_many :facebook_pages

  validates :token, presence: true
  validates :uid, presence: true, uniqueness: true
  validates :identity, presence: true

  acts_as_paranoid

  def create_facebook_pages
    retrieve_facebook_pages.each do |page|
      FacebookPage.find_or_create_by(page)
    end
  end

  def retrieve_facebook_pages
    pages = graph.get_connections("me", "accounts")
    pages.map! do |page|
      {
        name: page["name"],
        category: page["category"],
        uid: page["id"],
        token: page["access_token"],
        facebook_account_id: self.id,
        page_url: "https://www.facebook.com/#{page["id"]}",
        picture: graph.get_picture(page["id"])
      }
    end
  end

  private

  def graph
    Koala::Facebook::API.new(token, ENV["FACEBOOK_APP_SECRET"])
  end

end
