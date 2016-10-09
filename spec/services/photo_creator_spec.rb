describe PhotoCreator do

  let(:proposal) { create(:proposal) }
  let(:creator) { PhotoCreator.new(proposal) }
  let(:params) do
    {
      "utf8"=>"✓",
       "authenticity_token"=>"qLYzCezkqYCzwhU7oyFpNLSMexlbdJDP3Rr9b8rDYh2I3Crf/zEXBq9M+x+1+AEgXwhWAI6t686L0JiaRv6ETQ==",
       "file"=>"",
       "photo_type"=>"initial",
       "proposal_id"=>"#{proposal.id}",
       "commit"=>"Save Photos",
       "photos"=>
        ["image/upload/v1475970803/bzsfggqtgdaopngenoza.jpg#04a200007393c9e312534aa83308304da6d4997f",
         "image/upload/v1475970803/xypuu0cku44esy3n6avi.jpg#d4563384f7e98c6554ef181b0bfdcfc64ce292aa",
         "image/upload/v1475970803/bs25n1xt8mnx4kzfxfdz.jpg#7b644314e8c02d4560f06ca47e0c2915f780e445",
         "image/upload/v1475970804/hihjyaxc2srjfje9jkei.jpg#dce9db621a6c98667c31e0eb19b1c1fc06ad6e04"],
       "controller"=>"photos",
       "action"=>"batch_create"
    }.symbolize_keys!
  end

  it "can be instantiated" do
    expect(creator).to be_an_instance_of(PhotoCreator)
  end

  it "creates mulitple photos" do
    expect {
      creator.create_multiple(params)
    }.to change {
      proposal.photos.count
    }.by(4)
  end

  it "bails out gracefully if photo attrs nil" do
    params.delete(:photos)

    expect {
      creator.create_multiple(params)
    }.not_to raise_error(NoMethodError)
  end

  it "does not create photos if photo attrs nil" do
    params.delete(:photos)

    expect {
      creator.create_multiple(params)
    }.not_to change {
      Photo.count
    }
  end

end
