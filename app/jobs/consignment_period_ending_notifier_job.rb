class ConsignmentPeriodEndingNotifierJob < ActiveJob::Base
  queue_as :cron

  def perform
    execute
  end

  private

  def execute
    build_letters
  end

  def build_letters
    # delivering the letters will trigger deilvery by email
    LetterCreator.new(accounts).create_letters
  end

  def accounts
    Account.active.joins(jobs: [proposals: :agreements]).merge(Agreement.consign.active).where(agreements: {client_agreed_at: 60.days.ago..61.days.ago})
  end

end
