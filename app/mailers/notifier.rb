class Notifier < ApplicationMailer
  helper :application
  # include SendGrid
  self.asset_host = nil
  include Roadie::Rails::Mailer

  default from: 'notifications@jtrpfurniture.com'
  # sendgrid_category :use_subject_lines
  # sendgrid_enable :ganalytics, :opentrack

  def send_daily_summary_email(user, timeframe=nil, recipient=nil)
    @company = Company.jtrp
    user ||= default_user
    @user = user
    timeframe ||= default_timeframe
    @orders = orders(timeframe)
    recipient ||= default_recipient

    roadie_mail(to: recipient, subject: 'Daily Sales Summary', from: 'Just the Right Piece <notifications@jtrpfurniture.com>')
  end

  def send_proposal(proposal)
    @company = Company.jtrp
    @user = default_user
    @recipient = proposal.account.primary_contact
    @proposal = proposal
    mail(to: @recipient.email, subject: "You have a new proposal!", from: 'Carole at Just the Right Piece <carole@jtrpfurniture.com>')
  end

  private

  def default_user
    @company.primary_contact
  end

  def default_timeframe
    DateTime.now.in_time_zone("Eastern Time (US & Canada)").beginning_of_day..DateTime.now.in_time_zone("Eastern Time (US & Canada)")
  end

  def orders(timeframe)
    Order.paid.where(created_at: timeframe).uniq.order(:created_at)
  end

  def default_recipient
    @company.team_email
  end

end
