describe User do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:status) }

  it "internal?" do
    user = create(:user, :internal)

    expect(user.vendor?).to be(false)
    expect(user.internal?).to be(true)
    expect(user.client?).to be(false)
    expect(user.agent?).to be(false)
  end

  it "client?" do
    user = create(:user, :client)

    expect(user.vendor?).to be(false)
    expect(user.client?).to be(true)
    expect(user.internal?).to be(false)
    expect(user.agent?).to be(false)
  end

  it "vendor?" do
    user = create(:user, :vendor)

    expect(user.vendor?).to be(true)
    expect(user.client?).to be(false)
    expect(user.internal?).to be(false)
    expect(user.agent?).to be(false)
  end

  it "agent?" do
    user = create(:user, :agent)

    expect(user.vendor?).to be(false)
    expect(user.agent?).to be(true)
    expect(user.internal?).to be(false)
    expect(user.client?).to be(false)
  end

  it "active?" do
    user = create(:user)

    expect(user.active?).to be(true)
    expect(user.inactive?).to be(false)
  end

  it "inactive?" do
    user = create(:user, :inactive)

    expect(user.inactive?).to be(true)
    expect(user.active?).to be(false)
  end

  it "full_name" do
    user = create(:user, first_name: "Fred", last_name: "LeChat")

    expect(user.full_name).to eq("Fred LeChat")
  end

  describe "scopes" do

    before do
      create_list(:user, 3, :client)
      create_list(:user, 4, :vendor)
      create_list(:user, 3, :agent)
      create_list(:user, 3, :internal)
      create_list(:user, 2, :inactive)
    end

    it "client" do
      expect(User.client.count).to eq(3)
      User.client.each do |user|
        expect(user.client?).to be(true)
      end
    end

    it "vendor" do
      expect(User.vendor.count).to eq(4)
      User.vendor.each do |user|
        expect(user.vendor?).to be(true)
      end
    end

    it "agent" do
      expect(User.agent.count).to eq(3)
      User.agent.each do |user|
        expect(user.agent?).to be(true)
      end
    end

    it "internal" do
      expect(User.internal.count).to eq(3)
      User.internal.each do |user|
        expect(user.internal?).to be(true)
      end
    end

    it "active" do
      expect(User.active.count).to eq(13)
      User.active.each do |user|
        expect(user.active?).to be(true)
      end
    end

    it "inactive" do
      expect(User.inactive.count).to eq(2)
      User.inactive.each do |user|
        expect(user.inactive?).to be(true)
      end
    end

  end

end
