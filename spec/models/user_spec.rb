describe User do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:status) }

  it "internal?" do
    user = create(:internal_user)

    expect(user.internal?).to be(true)
    expect(user.client?).to be(false)
  end

  it "client?" do
    user = create(:client)

    expect(user.client?).to be(true)
    expect(user.internal?).to be(false)
  end

  it "full_name" do
    user = create(:user, first_name: "Fred", last_name: "LeChat")

    expect(user.full_name).to eq("Fred LeChat")
  end

  it "inverse_full_name" do
    user = create(:user, first_name: "Fred", last_name: "LeChat")

    expect(user.full_name).to eq("LeChat, Fred")
  end

  describe "scopes" do

    before do
      create_list(:client, 3)
      create_list(:internal_user, 3)
      create_list(:user, 2, :inactive)
    end

    it "client" do
      expect(User.client.count).to eq(3)
      User.client.each do |user|
        expect(user.client?).to be(true)
      end
    end

    it "internal" do
      expect(User.internal.count).to eq(3)
      User.internal.each do |user|
        expect(user.internal?).to be(true)
      end
    end

  end

end
