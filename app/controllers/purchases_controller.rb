class PurchasesController < ApplicationController
  before_action :require_internal

  def index
    @agreements = AgreementsPresenter.new(filters: {by_type: "sell"}).filter
    @title = "Purchase Orders"
  end

  def show
    @agreement = Agreement.find(params[:id])
    @account = @agreement.account
    @job = @agreement.job
    @items = @agreement.items.where.not(status: "potential").order(:account_item_number)
    @title = "#{@job.name} - Proposal #{@agreement.proposal.id} - #{@agreement.humanized_agreement_type}"
  end

  def edit
    @agreement = Agreement.find(params[:id])
    @account = @agreement.account
    @job = @agreement.job
    @items = @agreement.items.where.not(status: "potential").order(:account_item_number)
    @title = "#{@job.name} - Proposal #{@agreement.proposal.id} - #{@agreement.humanized_agreement_type}"
  end

  def update
    @agreement = Agreement.find(params[:id])
    if params[:agreement][:date]
      params[:agreement][:date] = DateTime.strptime(params[:agreement][:date], '%m/%d/%Y')
    end
    if @agreement.update(agreement_params)
      notice = 'Purchase order was successfully updated.'
    else
      notice = 'Unable to update purchase order.'
    end
    redirect_to purchase_path(@agreement), notice: notice
  end

  def destroy
    @agreement = Agreement.find(params[:id])
    if @agreement.destroy
      notice = "Agreement destroyed"
      redirect_to purchases_path, notice: notice
    else
      notice = "Agreement could not be destroyed"
      redirect_back(fallback_location: root_path, notice: notice)
    end

  end

  protected

  def agreement_params
    params.require(:agreement).permit(:service_charge, :date, :check_number)
  end

end
