describe ItemsPresenter do

  let(:potential_items) { create_list(:item, 3) }
  let(:active_items) { create_list(:item, 3, :active) }
  let(:sold_items) { create_list(:item, 2, :sold) }

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
    to_do_items = create_list(:item, 2, :active, listing_price: nil)

    expect(ItemsPresenter.new.todo).to eq(to_do_items)
  end

end
