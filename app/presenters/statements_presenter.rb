class StatementsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Statement.includes(:agreement, :account).filter(params.slice(:status))
  end

  def todo
    Statement.includes(:agreement, account: :primary_contact).where("statements.status = ? OR statements.check_number IS NULL", "unpaid")
  end

end
