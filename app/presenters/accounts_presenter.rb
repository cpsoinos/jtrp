class AccountsPresenter

  attr_reader :params, :filters, :accounts

  def initialize(params={}, accounts=nil)
    @params = params
    @filters = params.slice(:status)
    @accounts = account_base
  end

  def filter
    @accounts = @accounts.filter(filters)
    self
  end

  def sort
    @accounts = @accounts.order("users.last_name")
    self
  end

  def paginate
    @accounts = @accounts.page(page_params)
  end

  def execute
    filter.sort.paginate
    @accounts
  end

  private

  def account_base
    Account.includes([:primary_contact, jobs: :proposals]).joins(:primary_contact)
  end

end
