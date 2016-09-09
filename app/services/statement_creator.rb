class StatementCreator

  attr_reader :agreement

  def initialize(agreement)
    @agreement = agreement
  end

  def create
    statement = agreement.statements.new
    statement.balance_cents = agreement.items.sold.where(sold_at: 1.month.ago..Date.today).sum(:sale_price_cents)
    statement.date = DateTime.now
    statement.save
    statement
  end

end
