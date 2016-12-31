describe ItemsPresenter do

  let(:potential_items) { Item.potential }
  let(:active_items) { Item.active }
  let(:sold_items) { Item.sold }

  before do
    create_list(:item, 3)
    create_list(:item, 3, :active)
    create_list(:item, 2, :sold)
  end

  it 'can be instantiated' do
    expect(ItemsPresenter.new).to be_an_instance_of(ItemsPresenter)
  end

  it 'returns items' do
    items = ItemsPresenter.new.execute

    expect(items.count).to eq(Item.count)
    items.each do |item|
      expect(item).to be_in(Item.all)
    end
  end

  context 'filters' do

    it 'returns potential items' do
      items = ItemsPresenter.new(status: 'potential').execute

      expect(items.count).to eq(potential_items.count)
      items.each do |item|
        expect(item).to be_in(potential_items)
      end
    end

    it 'returns active items' do
      items = ItemsPresenter.new(status: 'active').execute

      expect(items.count).to eq(active_items.count)
      items.each do |item|
        expect(item).to be_in(active_items)
      end
    end

    it 'returns sold items' do
      items = ItemsPresenter.new(status: 'sold').execute

      expect(items.count).to eq(sold_items.count)
      items.each do |item|
        expect(item).to be_in(sold_items)
      end
    end

  end

  it 'todo' do
    sold_with_price = Item.sold.last
    sold_with_price.update_attributes(sold_at: DateTime.now, sale_price_cents: 1234)
    items = ItemsPresenter.new.todo

    items.each do |item|
      expect(item).to be_in(potential_items | active_items | sold_items.except(sold_with_price))
    end

    expect(sold_with_price).not_to be_in(items)
  end

end
