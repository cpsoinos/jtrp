class ApplicationMailer < ActionMailer::Base
  default from: "notifications@jtrpfurniture.com"
  layout 'mailer'

  def default_user
    @company.primary_contact
  end

end
