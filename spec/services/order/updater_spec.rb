describe Order::Updater do

  let(:order) { create(:order, remote_id: "KJHCCYXHV3ZDY") }
  let(:updater) { Order::Updater.new(order) }

  it "can be instantiated" do
    expect(updater).to be_an_instance_of(Order::Updater)
  end

  context "remote object changed", :vcr do

    let!(:mug) { create(:item, description: "Merry mug", remote_id: "93NZBJHHZBW2C", listing_price_cents: 100) }
    let!(:chair) { create(:item, description: "1 chair black seat", remote_id: "9X75TCHDWZVXW", listing_price_cents: 1500) }
    let!(:shelf) { create(:item, description: "1 pc Corner book shelf", remote_id: "8TJ09PJ69Z0GJ", listing_price_cents: 6000) }

    # before do
    #   allow(updater).to receive(:remote_object_changed?).and_return(true)
    # end

    it "updates the order's amount" do
      expect {
        updater.update
      }.to change {
        order.amount_cents
      }.by(7600)
    end

    it "retrieves items" do
      expect {
        updater.update
      }.to change {
        order.items.count
      }.by(3)
      expect(order.items).to match_array([mug, chair, shelf])
    end

    it "removes an item if cleared from clover order" do
      rogue_item = create(:item, :active, remote_id: "not_in_this_order")
      order.items << rogue_item

      expect(order.items).to include(rogue_item)

      updater.update

      expect(order.items).to match_array([mug, chair, shelf])
      expect(rogue_item.reload).to be_active
    end

    context "discounts" do

      context "on full order" do

        let(:order_with_discount) { create(:order, remote_id: "TDF8DFBQHYYNE") }
        let!(:basket) { create(:item, :active, description: "brown wicker flower basket", remote_id: "14PKM2V26HN30", listing_price_cents: 1200) }
        let!(:cabinet) { create(:item, :active, description: "Buffet/wine cabinet", remote_id: "ZKV3KVFNAQF2A", listing_price_cents: 25000) }
        let(:updater) { Order::Updater.new(order_with_discount) }
        subject { updater.update }

        it "retrieves order discounts" do
          expect {
            subject
          }.to change {
            Discount.count
          }.by(1)
        end

        it "sets discountable to order" do
          subject
          expect(Discount.first.discountable).to eq(order_with_discount)
        end

        it "applies discount to items" do
          subject

          expect(basket.reload.sale_price_cents).to eq(900)
          expect(cabinet.reload.sale_price_cents).to eq(18750)
          expect(order_with_discount.amount_cents).to eq(order_with_discount.items.sum(:sale_price_cents))
        end

      end

      context "on an individual item" do

        let(:order_with_item_discount) { create(:order, remote_id: "PGQR8K1YD9AGE") }
        let!(:dining_set) { create(:item, :active, description: "Dining Room Table 6 Chairs 2 Arm 4 Side 2 Leafs Cherry", remote_id: "Z0K3MWBA8JHPP", listing_price_cents: 30000) }
        let(:updater) { Order::Updater.new(order_with_item_discount) }
        subject { updater.update }

        it "retrieves item discounts" do
          expect {
            subject
          }.to change {
            Discount.count
          }.by(1)
        end

        it "sets discountable to item" do
          subject

          expect(Discount.first.discountable).to eq(dining_set)
        end

        it "applies discount to item" do
          subject

          expect(dining_set.reload.sale_price_cents).to eq(27000)
          expect(order_with_item_discount.amount_cents).to eq(27000)
        end

      end

      context "on multiple individual items" do

        let(:order_with_item_discounts) { create(:order, remote_id: "28QHBJ7FA1EB4") }
        let!(:chair) { create(:item, :active, description: "2pc Sectional Brown faux leather w/ ottoman", remote_id: "B4ZJHJK63KGZM", listing_price_cents: 30000) }
        let!(:frame) { create(:item, :active, description: "8\"x10\" Black Frame", remote_id: "4D2M7EXEAHV74", listing_price_cents: 500) }
        let(:updater) { Order::Updater.new(order_with_item_discounts) }
        subject { updater.update }

        it "retrieves item discounts" do
          expect {
            subject
          }.to change {
            Discount.count
          }.by(2)
        end

        it "sets discountable to item" do
          subject

          expect(Discount.all.map(&:discountable)).to match_array([chair, frame])
        end

        it "applies discounts to items" do
          subject

          expect(chair.reload.sale_price_cents).to eq(22500)
          expect(frame.reload.sale_price_cents).to eq(400)
          expect(order_with_item_discounts.amount_cents).to eq(22900)
        end

      end
    end

    it "records payment" do
      expect {
        updater.update
      }.to change {
        Payment.count
      }.by (1)

      expect(order.amount_cents).to eq(Payment.first.amount_cents)
    end

    it "sets timestamps" do
      updater.update
      expect(order.created_at).to eq(Time.at(1487450092000/1000))
      expect(order.updated_at).to eq(Time.at(1487450237000/1000))
    end

  end
  # 
  # context "remote object has not changed" do
  #
  #   before do
  #     allow_any_instance_of(Order::Updater).to receive(:remote_object_changed?).and_return(false)
  #   end
  #
  #   it "returns if remote object has not changed" do
  #     expect(updater.update).to eq("order unchanged")
  #   end
  #
  # end

end
