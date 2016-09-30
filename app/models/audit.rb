class Audit < ActiveRecord::Base

  belongs_to :auditable, polymorphic: true
  belongs_to :user

  after_create :record_activity

  private

  def record_activity
    "#{user.try(:full_name)} #{action}ed #{auditable_type.downcase.with_indefinite_article}: #{ActionController::Base.helpers.link_to(name_map(auditable), link_map(auditable))}"
  end

  def name_map(object)
    {
      account: object.full_name,
      agreement: object.short_name,
      category: object.name,
      company: object.name,
      item: object.description.titleize,
      job: object.name,
      proposal: object.account.full_name,
      scanned_agreement: object.agreement.account.full_name,
      statement: object.agreement.account.full_name,
      statement_pdf: object.statement.agreement.account.full_name,
      user: user.full_name
    }
  end

  def link_map(object)
    {
      account: account_url(object),
      agreement: agreement_url(object),
      category: category_url(object),
      company: landing_page_url,
      item: item_url(object),
      job: account_job_url(object.account, object),
      proposal: account_job_proposal_url(object.account, object.job, object),
      scanned_agreement: agreement_url(object.agreement),
      statement: statement_url(object),
      statement_pdf: statement_url(object),
      user: user_url(object)
    }
  end

end
