class ItemSpreadsheetsController < ApplicationController

  def create
    find_proposal
    @item_spreadsheet = ItemSpreadsheet.new(item_spreadsheet)
    if @item_spreadsheet.save_and_process_items(@proposal)
      flash[:notice] = "Items being processed"
      redirect_to edit_account_job_proposal_path(@proposal.account, @proposal.job, @proposal)
    else
      redirect_to :back
    end
  end

  protected

  def item_spreadsheet
    params.require(:item_spreadsheet).permit(:key, :proposal_id)
  end

end
