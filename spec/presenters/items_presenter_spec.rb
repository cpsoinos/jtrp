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
    expect(ItemsPresenter.new.filter).to eq(Item.all)
  end

  context 'filters' do

    it 'returns potential items' do
      expect(ItemsPresenter.new(status: 'potential').filter).to eq(potential_items)
    end

    it 'returns active items' do
      expect(ItemsPresenter.new(status: 'active').filter).to eq(active_items)
    end

    it 'returns sold items' do
      expect(ItemsPresenter.new(status: 'sold').filter).to eq(sold_items)
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
