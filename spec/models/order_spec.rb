describe Order do

  it { should have_many(:items) }
  it { should have_many(:discounts) }
  it { should belong_to(:customer) }

  describe "#process_webhook" do

    let(:order) { create(:order) }
    let(:webhook) { create(:webhook) }
    let(:remote_order) { double("remote_order") }
    let(:line_items) { double("line_items") }
    let(:elements) { DeepStruct.wrap([{item: {id: "1234"}, name: "some name", alternateName: Faker::Code.ean}, {name: "Manual Transaction"}]) }

    before do
      allow(Clover::Inventory).to receive(:delete)
      allow(Clover::Order).to receive(:find).with(order).and_return(remote_order)
      allow(remote_order).to receive(:lineItems).and_return(line_items)
      allow(line_items).to receive(:elements).and_return(elements)
      allow(remote_order).to receive(:total).and_return(1500)
      allow(remote_order).to receive(:state).and_return("locked")
      allow(remote_order).to receive(:createdTime).and_return(4567)
      allow(remote_order).to receive(:modifiedTime).and_return(8963)
    end

    it "updates order price from webhook" do
      order.process_webhook
      expect(order.amount_cents).to eq(1500)
    end

    it "does not fail if remote order not found" do
      allow(Clover::Order).to receive(:find).with(order).and_return(nil)
      expect{order.process_webhook}.not_to raise_error
    end

    it "calculates thirty day revenue" do
      orders = create_list(:order, 3, created_at: 5.days.ago, amount_cents: 5000)
      expect(Order.thirty_day_revenue).to eq(150)
    end

    it "does not include older orders in thirty day revenue" do
      create(:order, amount_cents: 5000, created_at: 40.days.ago)
      orders = create_list(:order, 3, created_at: 5.days.ago, amount_cents: 5000)
      expect(Order.thirty_day_revenue).to eq(150)
    end

    it "marks items sold when no discount applied" do
      create_list(:item, 3, :active, order: order, listing_price_cents: 500)
      order.process_webhook
      order.items.each do |item|
        expect(item).to be_sold
      end
    end

    it "marks items sold with a discount" do
      create_list(:item, 3, :active, order: order, listing_price_cents: 600)
      allow(Clover::Discount).to receive_message_chain(:find, :elements, :map).and_return(DeepStruct.wrap(
        [
          {
            item: {
              id: order.items.first.remote_id
            },
            name: order.items.first.description,
            discounts: {
              elements: [
                {
                  id: "1",
                  name: "first discount",
                  amount: -100
                }
              ]
            }
          },
          {
            item: {
              id: order.items.second.remote_id
            },
            name: order.items.second.description,
            discounts: {
              elements: [
                {
                  id: "2",
                  name: "second discount",
                  amount: -100
                }
              ]
            }
          },
          {
            item: {
              id: order.items.third.remote_id
            },
            name: order.items.third.description,
            discounts: {
              elements: [
                {
                  id: "3",
                  name: "third discount",
                  amount: -100
                }
              ]
            }
          }
        ]
      ))
      allow(Clover::Inventory).to receive(:delete)

      order.process_webhook
      order.items.each do |item|
        expect(item).to be_sold
        expect(item.sale_price_cents).to eq(500)
      end
    end

  end

end
