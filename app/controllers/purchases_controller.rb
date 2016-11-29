class PurchasesController < ApplicationController
  before_filter :require_internal

  def index
    @agreements = Agreement.by_type("sell")
  end

  def show
    @agreement = Agreement.find(params[:id])
    @account = @agreement.account
    @job = @agreement.job
    @items = @agreement.items
  end

end
