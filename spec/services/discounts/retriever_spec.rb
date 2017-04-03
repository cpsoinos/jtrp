module Discounts
  describe Retriever do

    let(:order) { create(:order, remote_id: "0APKFKJVAVGCR") }
    let(:retriever) { Discounts::Retriever.new(order) }

    it "can be instantiated" do
      expect(retriever).to be_an_instance_of(Discounts::Retriever)
    end

    it "retrieves order discounts", :vcr do
      expect {
        retriever.execute
      }.to change {
        Discount.count
      }.by(1)
    end

    it "retrieves item discounts", :vcr do
      pending("set up item discounts on clover dev kit")
      order = create(:order, remote_id: "PBSS1MMCZBZEC")

      expect {
        Discounts::Retriever.new(order).execute
      }.to change {
        Discount.count
      }.by(3)
    end

  end
end
