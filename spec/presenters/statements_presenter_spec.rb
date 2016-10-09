describe StatementsPresenter do

  let!(:paid_statements) { create_list(:statement, 3, :paid) }
  let!(:paid_no_check_number_statements) { create_list(:statement, 3, :paid, check_number: nil) }
  let!(:unpaid_statements) { create_list(:statement, 2) }

  it 'can be instantiated' do
    expect(StatementsPresenter.new).to be_an_instance_of(StatementsPresenter)
  end

  it 'returns statements' do
    expect(StatementsPresenter.new.filter.order(:id)).to eq(Statement.all.order(:id))
  end

  context 'filters' do

    it 'returns unpaid statements' do
      expect(StatementsPresenter.new(status: 'unpaid').filter).to eq(unpaid_statements)
    end

    it 'returns paid statements' do
      statements = StatementsPresenter.new(status: 'paid').filter
      (paid_statements | paid_no_check_number_statements).each do |statement|
        expect(statement).to be_in(statements)
      end
    end

  end

  it 'todo' do
    statements = StatementsPresenter.new.todo

    statements.each do |statement|
      expect(statement).to be_in(paid_no_check_number_statements | unpaid_statements)
      expect(statement).not_to be_in(paid_statements)
    end
  end

end
