class StatementUpdater

  attr_reader :statement, :attrs

  def initialize(statement)
    @statement = statement
  end

  def update(attrs)
    @attrs = attrs
    handle_payment
    statement.update(attrs)
  end

  private

  def handle_payment
    if attrs.delete(:status) == "paid"
      statement.pay
    end
  end

end
