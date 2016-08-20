require 'sendgrid-ruby'

class TransactionalEmailer
  include SendGrid

  attr_reader :proposal, :user

  def initialize(proposal, user)
    @proposal = proposal
    @user = user
  end

  def send_to_client(note=nil)
    response = build_email(note)
    record_response(response)
  end

  def send_notification(note=nil)
    response = build_notification(note)
    record_response(response)
  end

  private

  def build_email(note)
    mail = Mail.new
    mail.from = Email.new(email: 'carole@justtherightpiece.furniture')

    personalization = Personalization.new
    personalization.to = Email.new(email: proposal.account.primary_contact.email)
    personalization.substitutions = Substitution.new(key: '[name]', value: proposal.account.primary_contact.first_name)
    personalization.substitutions = Substitution.new(key: '[proposal_url]', value: proposal_url)
    if note.present?
      personalization.substitutions = Substitution.new(key: '[note]', value: note)
    end
    personalization.substitutions = Substitution.new(key: '[Sender_Name]', value: "Just the Right Piece")
    personalization.substitutions = Substitution.new(key: '[Sender_Address]', value: "369 South Broadway")
    personalization.substitutions = Substitution.new(key: '[Sender_City]', value: "Salem")
    personalization.substitutions = Substitution.new(key: '[Sender_State]', value: "NH")
    personalization.substitutions = Substitution.new(key: '[Sender_Zip]', value: "03079")
    mail.personalizations = personalization

    mail.template_id = '85fb04cb-9273-4718-8c64-858cf326c45d'

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    response.to_json
  end

  def build_notification(note)
    mail = Mail.new
    mail.from = Email.new(email: 'notifications@justtherightpiece.furniture')

    personalization = Personalization.new
    personalization.to = Email.new(email: proposal.created_by.email)
    personalization.substitutions = Substitution.new(key: '[name]', value: proposal.created_by.first_name)
    personalization.substitutions = Substitution.new(key: '[proposal_url]', value: proposal_url)
    personalization.substitutions = Substitution.new(key: '[client_name]', value: user.first_name)
    if note.present?
      personalization.substitutions = Substitution.new(key: '[note]', value: note)
    end
    personalization.substitutions = Substitution.new(key: '[Sender_Name]', value: "Just the Right Piece")
    personalization.substitutions = Substitution.new(key: '[Sender_Address]', value: "369 South Broadway")
    personalization.substitutions = Substitution.new(key: '[Sender_City]', value: "Salem")
    personalization.substitutions = Substitution.new(key: '[Sender_State]', value: "NH")
    personalization.substitutions = Substitution.new(key: '[Sender_Zip]', value: "03079")
    mail.personalizations = personalization

    mail.template_id = '8373e719-6755-406d-a638-9de068a8c83e'

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    response.to_json
  end

  def proposal_url
    Rails.application.routes.url_helpers.account_job_proposal_url(proposal.account, proposal.job, proposal, host: ENV['HOST'])
  end

  def record_response(response)
    TransactionalEmailRecord.create(recipient_id: proposal.account.primary_contact.id, created_by_id: user.id, category: "proposal", sendgrid_response: response)
  end

end