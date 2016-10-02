class Audited::Audit < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper

  def name_map
    case auditable_type
    when "Account"
      auditable.full_name
    when "Agreement"
      auditable.short_name
    when "Category"
      auditable.name
    when "Company"
      auditable.name
    when "Item"
      auditable.description.titleize
    when "Job"
      auditable.name
    when "Proposal"
      auditable.account.full_name
    when "ScannedAgreement"
      auditable.agreement.account.full_name
    when "Statement"
      auditable.agreement.account.full_name
    when "StatementPdf"
      auditable.statement.agreement.account.full_name
    when "User"
      user.full_name
    end
  end

  def link_map
    case auditable_type
    when "Account"
      Rails.application.routes.url_helpers.account_url(auditable, host: ENV['HOST'])
    when "Agreement"
      Rails.application.routes.url_helpers.agreement_url(auditable, host: ENV['HOST'])
    when "Category"
      Rails.application.routes.url_helpers.category_url(auditable, host: ENV['HOST'])
    when "Company"
      Rails.application.routes.url_helpers.landing_page_url
    when "Item"
      Rails.application.routes.url_helpers.item_url(auditable, host: ENV['HOST'])
    when "Job"
      Rails.application.routes.url_helpers.account_job_url(auditable.account, auditable, host: ENV['HOST'])
    when "Proposal"
      Rails.application.routes.url_helpers.account_job_proposal_url(auditable.account, auditable.job, auditable, host: ENV['HOST'])
    when "ScannedAgreement"
      Rails.application.routes.url_helpers.agreement_url(auditable.agreement, host: ENV['HOST'])
    when "Statement"
      Rails.application.routes.url_helpers.statement_url(auditable, host: ENV['HOST'])
    when "StatementPdf"
      Rails.application.routes.url_helpers.statement_url(auditable, host: ENV['HOST'])
    when "User"
      Rails.application.routes.url_helpers.user_url(auditable, host: ENV['HOST'])
    end
  end

end
