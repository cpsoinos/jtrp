describe ClientsPresenter do

  let(:active_clients) { create_list(:client, 3, :active) }
  let(:inactive_clients) { create_list(:client, 2, :inactive) }

  it 'can be instantiated' do
    expect(ClientsPresenter.new).to be_an_instance_of(ClientsPresenter)
  end

  it 'returns clients' do
    expect(ClientsPresenter.new.filter).to eq(Client.all)
  end

  context 'filters' do

    it 'returns active clients' do
      expect(ClientsPresenter.new(status: 'active').filter).to eq(active_clients)
    end

    it 'returns inactive clients' do
      expect(ClientsPresenter.new(status: 'inactive').filter).to eq(inactive_clients)
    end

  end

end
