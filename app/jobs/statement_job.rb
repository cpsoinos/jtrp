class StatementJob < ApplicationJob
  queue_as :cron

  def perform
    generate_statements
  end

  private

  def accounts
    @_accounts ||= begin
      Item.sold.where(client_intention: "consign", sold_at: sale_date_range, expired: false).map(&:account).uniq
    end
  end

  def generate_statements
    accounts.each do |account|
      statement = Statement::Creator.new(account).create
      if statement.amount_due_to_client == 0
        statement.pay
      end
    end
  end

  def save_as_pdf(statement)
    PdfGenerator.new(statement).render_pdf
  end

  def sale_date_range
    DateTime.now.last_month.beginning_of_month..DateTime.now.last_month.end_of_month
  end

end
