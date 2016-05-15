describe GeolocationService do

  let(:client) { create(:client, address_1: "1 Drury Ln", address_2: nil, city: "Boston", state: "MA", zip: "12345") }
  let(:expected_url) { "https://maps.googleapis.com/maps/api/staticmap?center=1+Drury+Ln++Boston,MA+12345&zoom=13&size=200x200&maptype=roadmap&markers=color:blue%7Clabel:Client%7C1+Drury+Ln++Boston,MA+12345&key=secret" }

  before do
    allow(ENV).to receive(:[]).with("GOOGLE_MAPS_API_KEY").and_return("secret")
  end

  it "can be instantiated" do
    expect(GeolocationService.new(client)).to be_an_instance_of(GeolocationService)
  end

  it "generates a static Google Maps URL" do
    expect(GeolocationService.new(client).static_map_url).to eq(expected_url)
  end

end
