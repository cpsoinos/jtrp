crumb :root do
  link "Dashboard", root_path
end

crumb :accounts do
  link "Accounts", accounts_path
end

crumb :account do |account|
  link account.short_name, account_path(account)
  parent :accounts
end

crumb :account_jobs do |account|
  link "Jobs", account_jobs_path(account)
  parent :account, account
end

crumb :job do |job|
  link job.address_1, account_job_path(job.account, job)
  parent :account_jobs, job.account
end

crumb :jobs do
  link "Jobs", jobs_path
end

crumb :job_proposals do |job|
  link "Proposals", account_job_proposals_path(job.account, job)
  parent :job, job
end

crumb :proposal do |proposal|
  link "Proposal #{proposal.id}", account_job_proposal_path(proposal.account, proposal.job, proposal)
  parent :job_proposals, proposal.job
end

crumb :proposal_agreements do |proposal|
  link "Agreements", account_job_proposal_agreements_path(proposal.account, proposal.job, proposal)
  parent :proposal, proposal
end

crumb :agreement do |agreement|
  link "#{agreement.humanized_agreement_type} #{agreement.id}", account_job_proposal_agreement_path(agreement.account, agreement.job, agreement.proposal, agreement)
  parent :proposal_agreements, agreement.proposal
end

crumb :proposal_items do |proposal|
  link "Items", account_job_proposal_items_path(proposal.account, proposal.job, proposal)
  parent :proposal, proposal
end

crumb :item do |item|
  link item.description.titleize, account_job_proposal_item_path(item.account, item.job, item.proposal, item)
  parent :proposal_items, item.proposal
end

crumb :purchases do
  link "Purchase List", purchases_path
end

crumb :purchase do |agreement|
  link "#{agreement.humanized_agreement_type} #{agreement.id}", agreement_path(agreement)
  parent :purchases
end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
