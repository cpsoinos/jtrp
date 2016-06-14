describe AgreementsPresenter do

  let(:potential_agreements) { create_list(:agreement, 3) }
  let(:active_agreements) { create_list(:agreement, 3, :active) }
  let(:inactive_agreements) { create_list(:agreement, 2, :inactive) }

  it 'can be instantiated' do
    expect(AgreementsPresenter.new).to be_an_instance_of(AgreementsPresenter)
  end

  it 'returns agreements' do
    expect(AgreementsPresenter.new.filter).to eq(Agreement.all)
  end

  context 'filters' do

    it 'returns potential agreements' do
      expect(AgreementsPresenter.new(status: 'potential').filter).to eq(potential_agreements)
    end

    it 'returns active agreements' do
      expect(AgreementsPresenter.new(status: 'active').filter).to eq(active_agreements)
    end

    it 'returns inactive agreements' do
      expect(AgreementsPresenter.new(status: 'inactive').filter).to eq(inactive_agreements)
    end

  end

end
