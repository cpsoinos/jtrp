module Statements
  class Creator

    attr_reader :account, :statement

    def initialize(account)
      @account = account
    end

    def create
      build_statement
      track_activity
      gather_items
      statement
    end

    private

    def build_statement
      @statement = account.statements.create(date: DateTime.now)
    end

    def track_activity
      statement.create_activity(:create, owner: Admin.first)
    end

    def gather_items
      Statements::ItemGatherer.new(statement, account).execute
    end

  end
end
