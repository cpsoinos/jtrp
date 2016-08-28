require 'sendgrid-ruby'

class TransactionalEmailer
  include SendGrid

  attr_reader :object, :user, :email_type

  def initialize(object, user, email_type)
    @object = object
    @user = user
    @email_type = email_type
  end

  def send(recipient, note=nil)
    response = build_email(recipient, note)
    record_response(response, recipient)
  end

  private

  def build_email(recipient, note=nil)
    mail = Mail.new
    mail.from = Email.new(email: (user.internal? ? user.email : "notifications@justtherightpiece.furniture"))

    mail.personalizations = personalizations(recipient, note)

    mail.template_id = template_hash[email_type]

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    response.to_json
  end

  def template_hash
    {
      "proposal" => '85fb04cb-9273-4718-8c64-858cf326c45d',
      "notification" => '8373e719-6755-406d-a638-9de068a8c83e',
      "agreement" => 'faae793c-7bf3-4f09-94c3-d0dda1c87fda',
      "send_agreement" => '53c7255e-09fe-43b6-9f5d-07b3d9001240',
      "agreement_active_notifier" => 'a44c4a4e-a852-4250-bd24-026c74da4ca8'
    }
  end

  def personalizations(recipient, note=nil)
    personalization = Personalization.new
    personalization.to = Email.new(email: recipient.email)
    personalization.substitutions = Substitution.new(key: '[name]', value: recipient.first_name)
    personalization.substitutions = Substitution.new(key: '[client_name]', value: user.first_name)
    personalization.substitutions = Substitution.new(key: '[object_url]', value: object.object_url)
    if note.present?
      personalization.substitutions = Substitution.new(key: '[note]', value: note)
    end
    personalization.substitutions = Substitution.new(key: '[Sender_Name]', value: "Just the Right Piece")
    personalization.substitutions = Substitution.new(key: '[Sender_Address]', value: "369 South Broadway")
    personalization.substitutions = Substitution.new(key: '[Sender_City]', value: "Salem")
    personalization.substitutions = Substitution.new(key: '[Sender_State]', value: "NH")
    personalization.substitutions = Substitution.new(key: '[Sender_Zip]', value: "03079")
    personalization
  end

  def record_response(response, recipient)
    TransactionalEmailRecord.create(recipient_id: recipient.id, created_by_id: user.id, category: email_type, sendgrid_response: response)
  end

end
