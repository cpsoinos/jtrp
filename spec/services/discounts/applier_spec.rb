module Discounts
  describe Applier do

    context "item" do
      context "flat rate" do

        let(:discount) { create(:discount) }
        let(:item) { discount.discountable }
        let(:applier) { Discounts::Applier.new(discount) }

        it "can be instantiated" do
          expect(applier).to be_an_instance_of(Discounts::Applier)
        end

        it "applies a discount to an item" do
          applier.execute
          expect(item.sale_price_cents).to eq(4000)
        end

        it "marks the discount as applied" do
          applier.execute
          expect(discount.applied?).to be(true)
        end

      end

      context "percentage based" do

        let(:discount) { create(:discount, :percent_based) }
        let(:item) { discount.discountable }
        let(:applier) { Discounts::Applier.new(discount) }

        it "calculates the discount when percent-based" do
          applier.execute
          expect(item.sale_price_cents).to eq(4500)
        end

        it "marks the discount as applied" do
          applier.execute
          expect(discount.applied?).to be(true)
        end

      end
    end

    context "order" do
      context "flat rate" do

        let(:discount) { create(:discount, :for_order) }
        let(:order) { discount.discountable }
        let!(:items) { create_list(:item, 2, :active, listing_price_cents: 5000, order: order) }
        let(:applier) { Discounts::Applier.new(discount) }

        it "applies a discount to the items in an order" do
          applier.execute

          items.each do |item|
            expect(item.reload.sale_price_cents).to eq(4500)
          end
        end

        it "marks the discount as applied" do
          applier.execute
          expect(discount.applied?).to be(true)
        end

      end

      context "percentage based" do
        let(:discount) { create(:discount, :for_order, :percent_based) }
        let(:order) { discount.discountable }
        let!(:items) { create_list(:item, 2, :active, listing_price_cents: 5000, order: order) }
        let(:applier) { Discounts::Applier.new(discount) }

        it "applies a discount to the items in an order" do
          applier.execute

          items.each do |item|
            expect(item.reload.sale_price_cents).to eq(4500)
          end
        end

        it "marks the discount as applied" do
          applier.execute
          expect(discount.applied?).to be(true)
        end

      end
    end

  end
end

