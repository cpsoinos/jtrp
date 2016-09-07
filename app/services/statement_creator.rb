class StatementCreator

  attr_reader :agreement

  def initialize(agreement)
    @agreement = agreement
  end

  def create
    statement = agreement.statements.new
    statement.balance_cents = agreement.items.sold.sum(:sale_price_cents)
    statement.save
  end

end
