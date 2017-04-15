class OauthService

  attr_reader :auth_hash

  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def execute
    oauth_account = OauthAccount.find_or_initialize_by(uid: auth_hash[:uid])
    oauth_account.assign_attributes(oauth_account_params)
    oauth_account.save
    oauth_account
  end

  private

  def oauth_account_params
    {
      user: find_user,
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      remote_image_url: find_image_url,
      profile_url: find_profile_url,
      access_token: find_access_token,
      raw_data: auth_hash[:extra]
    }
  end

  def find_user
    user = User.find_or_initialize_by(email: auth_hash.info.email)
    unless user.persisted?
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name.split(" ").first   # assuming the user model has a name
      user.last_name = auth.info.name.split(" ").last   # assuming the user model has a name
      user.avatar = find_image_url
      user.save
    end
    user
  end

  def find_image_url
    auth_hash.dig(:info, :image)
  end

  def find_profile_url
    auth_hash.dig(:info, :urls, :Clover) ||
      auth_hash.dig(:info, :urls, :public_profile)
  end

  def find_access_token
    auth_hash.dig(:credentials, :token)
  end

end
