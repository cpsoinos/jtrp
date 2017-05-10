class GeolocationService

  attr_reader :object, :address_1, :city, :state, :zip, :country

  def initialize(object)
    @object = object
    pull_location_from_object
  end

  def static_map_url(size="800x800")
    "https://maps.googleapis.com/maps/api/staticmap?center=#{location_string}&zoom=13&size=#{size}&maptype=roadmap&markers=color:blue%7Clabel:Client%7C#{location_string}&key=#{api_key}"
  end

  def location_string
    string = "#{address_1} #{city},#{state} #{zip}"
    string.gsub!(" ", "+")
  end

  def directions_link
    "https://www.google.com/maps?saddr=My+Location&daddr=#{location_string}"
  end

  private

  def pull_location_from_object
    @address_1 = object.try(:address_1)
    @city = object.try(:city)
    @state = object.try(:state)
    @zip = object.try(:zip)
  end

  def api_key
    @_api_key ||= ENV["GOOGLE_MAPS_API_KEY"]
  end

end
