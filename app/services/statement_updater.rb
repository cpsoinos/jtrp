class StatementUpdater

  attr_reader :statement, :attrs

  def initialize(statement)
    @statement = statement
  end

  def update(attrs)
    @attrs = attrs
    statement.pay if attrs[:status] == "paid"
    statement.update(attrs)
  end

end
