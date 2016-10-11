class ConsignmentPeriodEndingNotifierJob < ActiveJob::Base
  queue_as :cron

  def perform
    LetterCreator.new(accounts).create
  end

  private

  def accounts
    Account.active.joins(jobs: [proposals: :agreements]).merge(Agreement.consign.active).where(agreements: {client_agreed_at: 60.days.ago..61.days.ago})
  end

end
