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
      if statement.amount_due_to_client == 0
        statement.pay
      end
      # save_as_pdf(statement)
    end
  end

  def save_as_pdf(statement)
    PdfGenerator.new(statement).render_pdf
  end

end
