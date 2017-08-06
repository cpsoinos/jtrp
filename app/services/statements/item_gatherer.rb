module Statements
  class ItemGatherer

    attr_reader :statement, :account

    def initialize(statement, account)
      @statement = statement
      @account   = account
    end

    def execute
      gather_items
    end

    private

    def gather_items
      statement.items << items
    end

    def items
      @_items ||= account.items.sold.where(client_intention: "consign", sold_at: statement.starting_date..statement.ending_date)
    end

  end
end
