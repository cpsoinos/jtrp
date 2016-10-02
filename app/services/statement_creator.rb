class StatementCreator

  attr_reader :agreement

  def initialize(agreement)
    @agreement = agreement
  end

  def create
    statement = agreement.statements.new
    statement.date = DateTime.now
    statement.save
    statement
  end

end
