require 'sendgrid-ruby'

class TransactionalEmailer
  include SendGrid

  attr_reader :proposal, :user

  def initialize(proposal, user)
    @proposal = proposal
    @user = user
  end

  def send
    response = build_email
    record_response(response)
  end

  private

  def build_email
    mail = Mail.new
    mail.from = Email.new(email: 'carole@justtherightpiece.furniture')

    personalization = Personalization.new
    personalization.to = Email.new(email: proposal.account.primary_contact.email)
    personalization.substitutions = Substitution.new(key: '[name]', value: proposal.account.primary_contact.first_name)
    personalization.substitutions = Substitution.new(key: '[proposal_url]', value: proposal_url)
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

  def proposal_url
    Rails.application.routes.url_helpers.account_job_proposal_url(proposal.account, proposal.job, proposal, host: ENV['HOST'])
  end

  def record_response(response)
    TransactionalEmailRecord.create(recipient_id: proposal.account.primary_contact.id, created_by_id: user.id, category: "proposal", sendgrid_response: response)
  end

end
