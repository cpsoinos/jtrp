class AgreementsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Agreement.filter(params.slice(:status))
  end

end
