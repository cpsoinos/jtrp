class StatementCreator

  attr_reader :agreement

  def initialize(agreement)
    @agreement = agreement
  end

  def create
    statement = agreement.statements.new
    statement.balance_cents = agreement.items.sold.sum(:sale_price_cents)
    statement.date = DateTime.now
    statement.save
    statement
  end

end
