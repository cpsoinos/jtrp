class Notifier < ApplicationMailer
  helper :application
  self.asset_host = nil
  include Roadie::Rails::Mailer

  default from: 'Just the Right Piece <notifications@jtrpfurniture.com>'

  def send_daily_summary_email(recipient, timeframe=nil)
    @company    = Company.jtrp
    @user       = default_user
    timeframe  ||= default_timeframe
    @orders     = orders(timeframe)
    @recipient  = recipient
    roadie_mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: 'Daily Sales Summary', from: 'Just the Right Piece <notifications@jtrpfurniture.com>')
  end

  def send_proposal(proposal, note)
    @company   = Company.jtrp
    @note      = note
    @user      = default_user
    @recipient = proposal.account.primary_contact
    @proposal  = proposal
    mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: "You have a new proposal!", from: "#{@user.first_name} at #{@company.name} <#{@user.email}>")
  end

  def send_proposal_response(proposal, note)
    @company   = Company.jtrp
    @note      = note
    @client    = proposal.account.primary_contact
    @recipient = default_user
    @proposal  = proposal
    mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: "#{@client.full_name} has responded to your proposal")
  end

  def send_agreement(agreement, note)
    @company   = Company.jtrp
    @note      = note
    @user      = default_user
    @recipient = agreement.account.primary_contact
    @agreement = agreement
    mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: "You have a pending #{@agreement.humanized_agreement_type}", from: "#{@user.first_name} at #{@company.name} <#{@user.email}>")
  end

  def send_agreement_active_notification(agreement)
    @company   = Company.jtrp
    @client    = agreement.account.primary_contact
    @recipient = default_user
    @agreement = agreement
    mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: "#{@client.full_name}'s #{@agreement.humanized_agreement_type} is active!")
  end

  def send_executed_agreement(agreement)
    @company   = Company.jtrp
    @user      = default_user
    @recipient = agreement.account.primary_contact
    @agreement = agreement
    attachments["#{agreement.short_name}.pdf"] = {
      mime_type: 'application/pdf',
      content:    open(agreement.pdf.url).read
    }
    mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: "Your #{@agreement.humanized_agreement_type} is ready", from: "#{@user.first_name} at #{@company.name} <#{@user.email}>")
  end

  def send_agreement_pending_expiration(letter)
    @company   = Company.jtrp
    @user      = default_user
    @recipient = letter.account.primary_contact
    @letter    = letter
    mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: "Your consignment period is coming to an end", from: "#{@user.first_name} at #{@company.name} <#{@user.email}>")
  end

  def send_agreement_expired(letter)
    @company   = Company.jtrp
    @user      = default_user
    @recipient = letter.account.primary_contact
    @letter    = letter
    mail(to: "#{@recipient.full_name} <#{@recipient.email}>", subject: "Your consignment period has ended", from: "#{@user.first_name} at #{@company.name} <#{@user.email}>")
  end

  def send_contact_us(from_name, from_email, subject, note, phone, address, photos=[])
    @company   = Company.jtrp
    @recipient = default_user
    @from_name = from_name
    @note      = note
    @phone     = phone
    @address   = address
    if photos.present?
      photos.each do |photo|
        attachments[photo.photo.send(:original_filename)] = open(photo.photo.url).read
      end
    end
    mail(from: "#{@from_name} <notifications@jtrpfurniture.com>", to: "#{@recipient.full_name} <#{@recipient.email}>", subject: subject, reply_to: from_email)
  end

  private

  def default_timeframe
    DateTime.now.in_time_zone("Eastern Time (US & Canada)").beginning_of_day..DateTime.now.in_time_zone("Eastern Time (US & Canada)")
  end

  def orders(timeframe)
    Order.paid.where(updated_at: timeframe).distinct.order(:updated_at)
  end

end
