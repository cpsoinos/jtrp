class AccountsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Account.includes(proposals: :statements).filter(params.slice(:status)).order(:account_number)
  end

end
