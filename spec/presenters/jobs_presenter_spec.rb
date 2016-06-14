describe JobsPresenter do

  let(:potential_jobs) { create_list(:job, 3) }
  let(:active_jobs) { create_list(:job, 3, :active) }
  let(:completed_jobs) { create_list(:job, 2, :completed) }

  it 'can be instantiated' do
    expect(JobsPresenter.new).to be_an_instance_of(JobsPresenter)
  end

  it 'returns jobs' do
    expect(JobsPresenter.new.filter).to eq(Job.all)
  end

  context 'filters' do

    it 'returns potential jobs' do
      expect(JobsPresenter.new(status: 'potential').filter).to eq(potential_jobs)
    end

    it 'returns active jobs' do
      expect(JobsPresenter.new(status: 'active').filter).to eq(active_jobs)
    end

    it 'returns completed jobs' do
      expect(JobsPresenter.new(status: 'completed').filter).to eq(completed_jobs)
    end

  end

end
