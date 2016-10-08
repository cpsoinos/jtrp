describe AccountsPresenter do

  let(:potential_accounts) { [Account.yard_sale, Account.estate_sale] | create_list(:client_account, 3) }
  let(:active_accounts) { create_list(:client_account, 3, :active) }
  let(:inactive_accounts) { create_list(:client_account, 2, :inactive) }

  it 'can be instantiated' do
    expect(AccountsPresenter.new).to be_an_instance_of(AccountsPresenter)
  end

  it 'returns accounts' do
    presenter = AccountsPresenter.new.filter
    
    presenter.each do |account|
      expect(account).to be_in(Account.all)
    end
  end

  context 'filters' do

    it 'returns potential accounts' do
      presenter = AccountsPresenter.new(status: 'potential').filter

      presenter.each do |account|
        expect(account).to be_in(potential_accounts)
      end
    end

    it 'returns active accounts' do
      presenter = AccountsPresenter.new(status: 'active').filter

      presenter.each do |account|
        expect(account).to be_in(active_accounts)
      end
    end

    it 'returns inactive accounts' do
      presenter = AccountsPresenter.new(status: 'inactive').filter

      presenter.each do |account|
        expect(account).to be_in(inactive_accounts)
      end
    end

  end

end
