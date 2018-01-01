module Items
  describe Expirer do

    let!(:items) { create_list(:item, 2, :active, :consigned, listed_at: 93.days.ago) }
    let(:expirer) { Items::Expirer.new(items) }

    it "can be instantiated" do
      expect(expirer).to be_an_instance_of(Items::Expirer)
    end

    it "expires items" do
      expect {
        expirer.execute
      }.to change {
        Item.expired.count
      }.by(2)
    end

  end
end
