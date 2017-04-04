module Orders
  describe Processor do

    let(:order) { create(:order, remote_id: "KJHCCYXHV3ZDY") }
    let(:processor) { Orders::Processor.new(order) }

    let!(:mug) { create(:item, id: 4035, description: "Merry mug", remote_id: "93NZBJHHZBW2C", token: '6wckpFnr2eAJ', listing_price_cents: 100) }
    let!(:chair) { create(:item, id: 6072, description: "1 chair black seat", remote_id: "9X75TCHDWZVXW", token: 'sdkSwpEfRJFx', listing_price_cents: 1500) }
    let!(:shelf) { create(:item, id: 4315, description: "1 pc Corner book shelf", remote_id: "8TJ09PJ69Z0GJ", token: 'h25zKQnF2VAG', listing_price_cents: 6000) }

    before do
      allow(InventorySyncJob).to receive(:perform_later)
    end

    it "can be instantiated" do
      expect(processor).to be_an_instance_of(Orders::Processor)
    end

    it "updates the order's amount", :vcr do
      expect {
        processor.process
      }.to change {
        order.amount_cents
      }.by(7600)
    end

    it "retrieves items", :vcr do
      expect {
        processor.process
      }.to change {
        order.items.count
      }.by(3)
      expect(order.items).to match_array([mug, chair, shelf])
    end

    context "discounts", :vcr do

      context "on full order" do

        let(:order_with_discount) { create(:order, remote_id: "TDF8DFBQHYYNE") }
        let!(:basket) { create(:item, :active, id: 4413, description: "brown wicker flower basket", remote_id: "14PKM2V26HN30", token: '2ijeu9Yt4meE', listing_price_cents: 1200) }
        let!(:cabinet) { create(:item, :active, id: 6227, description: "Buffet/wine cabinet", remote_id: "ZKV3KVFNAQF2A", token: '8sY4E3WCari9', listing_price_cents: 25000) }
        let(:processor) { Orders::Processor.new(order_with_discount) }
        subject { processor.process }

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
        let!(:dining_set) { create(:item, :active, id: 5436, description: "Dining Room Table 6 Chairs 2 Arm 4 Side 2 Leafs Cherry", token: 'Ehoca5fbk5zW', remote_id: "Z0K3MWBA8JHPP", listing_price_cents: 30000) }
        let(:processor) { Orders::Processor.new(order_with_item_discount) }
        subject { processor.process }

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
        let!(:chair) { create(:item, :active, id: 3926, description: "2pc Sectional Brown faux leather w/ ottoman", token: 'QJRMezjU7xXx', remote_id: "B4ZJHJK63KGZM", listing_price_cents: 30000) }
        let!(:frame) { create(:item, :active, id: 5857, description: "8\"x10\" Black Frame", token: 'QS6awrg7RaY1', remote_id: "4D2M7EXEAHV74", listing_price_cents: 500) }
        let(:processor) { Orders::Processor.new(order_with_item_discounts) }
        subject { processor.process }

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

    it "sets timestamps", :vcr do
      processor.process
      expect(order.created_at).to eq(Time.at(1487450092000/1000))
      expect(order.updated_at).to eq(Time.at(1487450237000/1000))
    end



  end
end
