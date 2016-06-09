class JobsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Job.filter(params.slice(:status))
  end

end
