class StatementJob < ActiveJob::Base
  queue_as :cron

  def perform
    generate_statements
  end

  private

  def agreements
    @_agreements ||= begin
      Item.sold.where(client_intention: "consign", sold_at: sale_date_range).map(&:agreement).uniq
    end
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

  def sale_date_range
    DateTime.now.last_month.beginning_of_month..DateTime.now.last_month.end_of_month
  end

end
