describe AccountsPresenter do

  let(:potential_accounts) { [Account.yard_sale, Account.estate_sale] | create_list(:account, 3) }
  let(:active_accounts) { create_list(:account, 3, :active) }
  let(:inactive_accounts) { create_list(:account, 2, :inactive) }

  it 'can be instantiated' do
    expect(AccountsPresenter.new).to be_an_instance_of(AccountsPresenter)
  end

  it 'returns accounts' do
    expect(AccountsPresenter.new.filter).to eq(Account.all.order(:account_number))
  end

  context 'filters' do

    it 'returns potential accounts' do
      expect(AccountsPresenter.new(status: 'potential').filter).to eq(potential_accounts)
    end

    it 'returns active accounts' do
      expect(AccountsPresenter.new(status: 'active').filter).to eq(active_accounts)
    end

    it 'returns inactive accounts' do
      expect(AccountsPresenter.new(status: 'inactive').filter).to eq(inactive_accounts)
    end

  end

end
