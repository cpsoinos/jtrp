class JobsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Job.includes(:account).filter(params.slice(:status, :account_id))
  end

end
