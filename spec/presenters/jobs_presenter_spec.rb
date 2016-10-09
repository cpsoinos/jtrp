describe JobsPresenter do

  let!(:potential_jobs) { create_list(:job, 3) }
  let!(:active_jobs) { create_list(:job, 3, :active) }
  let!(:completed_jobs) { create_list(:job, 2, :completed) }

  it 'can be instantiated' do
    expect(JobsPresenter.new).to be_an_instance_of(JobsPresenter)
  end

  it 'returns jobs' do
    expect(JobsPresenter.new.filter).to eq(Job.all)
  end

  context 'filters' do

    it 'returns potential jobs' do
      jobs = JobsPresenter.new(status: 'potential').filter

      expect(jobs.count).to eq(potential_jobs.count)
      jobs.each do |job|
        expect(job).to be_in(potential_jobs)
      end
    end

    it 'returns active jobs' do
      jobs = JobsPresenter.new(status: 'active').filter

      expect(jobs.count).to eq(active_jobs.count)
      jobs.each do |job|
        expect(job).to be_in(active_jobs)
      end
    end

    it 'returns completed jobs' do
      jobs = JobsPresenter.new(status: 'completed').filter

      expect(jobs.count).to eq(completed_jobs.count)
      jobs.each do |job|
        expect(job).to be_in(completed_jobs)
      end
    end

  end

end
