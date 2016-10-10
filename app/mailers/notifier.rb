class Notifier < ApplicationMailer
  helper :application
  helper :mailer
  include SendGrid

  default from: 'notifications@justtherightpiece.furniture'
  sendgrid_category :use_subject_lines
  sendgrid_enable :ganalytics, :opentrack

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_daily_summary_email(user)
    @company = Company.jtrp
    @user = user
    # @orders = Order.where(created_at: DateTime.now.beginning_of_day..DateTime.now)
    @orders = Order.where(created_at: 1.day.ago..DateTime.now)
    mail(to: @user.email, subject: 'Daily Sales Summary')
  end
end
