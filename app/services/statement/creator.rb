class Statement::Creator

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def create
    statement = account.statements.new
    statement.date = DateTime.now
    statement.save
    statement.create_activity(:create, owner: Admin.first)
    statement
  end

end
