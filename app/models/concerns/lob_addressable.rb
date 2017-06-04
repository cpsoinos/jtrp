module LobAddressable
  extend ActiveSupport::Concern

  def build_address(user)
    {
      name: user.full_name,
      address_line1: user.address_1,
      address_line2: user.address_2,
      address_city: user.city,
      address_state: state_abbreviation(user.state),
      address_country: "US",
      address_zip: user.zip
    }
  end

  private

  def state_abbreviation(state)
    if state.length > 2
      Madison.get_abbrev(state)
    else
      state
    end
  end

  def lob
    @_lob ||= Lob::Client.new(api_key: ENV['LOB_API_KEY'])
  end

end
