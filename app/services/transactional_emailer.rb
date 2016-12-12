require 'sendgrid-ruby'

class TransactionalEmailer
  include SendGrid

  attr_reader :object, :user, :email_type

  def initialize(object, user, email_type)
    @object = object
    @user = user
    @email_type = email_type
  end

  def send(recipient, options={})
    response = build_email(recipient, options)
    record_response(response, recipient)
  end

  private

  def build_email(recipient, options)
    mail = Mail.new
    mail.from = Email.new(from_email(options))

    mail.personalizations = personalizations(recipient, options)

    mail.template_id = template_hash[email_type]

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    response.to_json
  end

  def template_hash
    {
      'proposal'                      => '85fb04cb-9273-4718-8c64-858cf326c45d',
      'notification'                  => '8373e719-6755-406d-a638-9de068a8c83e',
      'agreement'                     => 'faae793c-7bf3-4f09-94c3-d0dda1c87fda',
      'send_agreement'                => '53c7255e-09fe-43b6-9f5d-07b3d9001240',
      'agreement_active_notifier'     => 'a44c4a4e-a852-4250-bd24-026c74da4ca8',
      'agreement_pending_expiration'  => '39421dcb-df09-47da-9abb-a3cbdf69acf0',
      'agreement_expired'             => '4c362444-967d-4558-9455-929cc1bd8392',
      'contact_us'                    => '787a8214-a2da-4a0d-a086-c60010c24916'
    }
  end

  def personalizations(recipient, options)
    personalization = Personalization.new
    personalization.to = Email.new(email: recipient.email)
    personalization.substitutions = Substitution.new(key: '[name]', value: recipient.first_name)
    personalization.substitutions = Substitution.new(key: '[client_name]', value: (user.try(:first_name) || ''))
    personalization.substitutions = Substitution.new(key: '[object_url]', value: (object.try(:object_url) || ''))
    personalization.substitutions = Substitution.new(key: '[pending_deadline]', value: (object.try(:pending_deadline) || ''))
    personalization.substitutions = Substitution.new(key: '[hard_deadline]', value: (object.try(:hard_deadline) || ''))
    personalization.substitutions = begin
      if options[:from_name].present?
        Substitution.new(key: '[from_name]', value: options[:from_name])
      else
        Substitution.new(key: '[from_name]', value: Company.jtrp.primary_contact.full_name)
      end
    end
    if options[:subject].present?
      personalization.substitutions = Substitution.new(key: '[subject]', value: options[:subject])
    end
    personalization.substitutions = Substitution.new(key: '[from_title]', value: "Owner")
    if options[:note].present?
      personalization.substitutions = Substitution.new(key: '[note]', value: options[:note])
    end
    personalization.substitutions = Substitution.new(key: '[Sender_Name]', value: "Just the Right Piece")
    personalization.substitutions = Substitution.new(key: '[Sender_Address]', value: "369 South Broadway")
    personalization.substitutions = Substitution.new(key: '[Sender_City]', value: "Salem")
    personalization.substitutions = Substitution.new(key: '[Sender_State]', value: "NH")
    personalization.substitutions = Substitution.new(key: '[Sender_Zip]', value: "03079")
    personalization
  end

  def record_response(response, recipient)
    TransactionalEmailRecord.create(recipient_id: recipient.id, created_by_id: user.try(:id), category: email_type, sendgrid_response: response)
  end

  def from_email(options)
    if user.try(:internal?)
      user.email
    elsif options[:email].present?
      options[:email]
    else
      "notifications@jtrpfurniture.com"
    end
  end

end
