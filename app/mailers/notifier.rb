class Notifier < ApplicationMailer
  helper :application
  include SendGrid

  default from: 'notifications@jtrpfurniture.com'
  sendgrid_category :use_subject_lines
  sendgrid_enable :ganalytics, :opentrack

  def send_daily_summary_email(user, timeframe=nil, recipient=nil)
    @company = Company.jtrp
    user ||= default_user
    @user = user
    timeframe ||= default_timeframe
    @orders = orders(timeframe)
    recipient ||= default_recipient

    mail(to: recipient, subject: 'Daily Sales Summary')
  end

  private

  def default_user
    @company.primary_contact
  end

  def default_timeframe
    DateTime.now.beginning_of_day..DateTime.now
  end

  def orders(timeframe)
    Order.where(created_at: DateTime.now.beginning_of_day..DateTime.now)
  end

  def default_recipient
    @company.team_email
  end

end
