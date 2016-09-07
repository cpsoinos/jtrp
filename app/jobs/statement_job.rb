class StatementJob < ActiveJob::Base
  queue_as :default

  def perform
    generate_statements
  end

  private

  def agreements
    @_agreements ||= Agreement.active.by_type("consign")
  end

  def generate_statements
    agreements.each do |agreement|
      statement = StatementCreator.new(agreement).create
      if statement.balance_cents == 0
        statement.pay
      end
    end
  end

end
