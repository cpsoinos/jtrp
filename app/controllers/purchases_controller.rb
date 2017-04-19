class PurchasesController < ApplicationController
  before_filter :require_internal

  def index
    @agreements = AgreementsPresenter.new(filters: {by_type: "sell"}).filter
    @title = "Purchase Orders"
  end

  def show
    @agreement = Agreement.find(params[:id])
    @account = @agreement.account
    @job = @agreement.job
    @items = @agreement.items
    @title = "#{@job.name} - Proposal #{@agreement.proposal.id} - #{@agreement.humanized_agreement_type}"
  end

end
