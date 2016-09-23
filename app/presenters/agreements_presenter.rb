class AgreementsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Agreement.includes(:proposal, :job, :account, {proposal: [:account, :primary_contact]}).filter(params.slice(:status))
  end

end
