class AccountsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Account.filter(params.slice(:status))
  end

end
