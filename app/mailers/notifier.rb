class Notifier < ApplicationMailer
  helper :application
  include SendGrid

  default from: 'notifications@justtherightpiece.furniture'
  sendgrid_category :use_subject_lines
  sendgrid_enable :ganalytics, :opentrack

  def send_daily_summary_email(user)
    @company = Company.jtrp
    @user = user
    @orders = Order.where(created_at: DateTime.now.beginning_of_day..DateTime.now)
    mail(to: @company.team_email, subject: 'Daily Sales Summary')
  end
end
