class ScannedAgreementsController < ApplicationController
  before_filter :require_internal
  before_filter :find_agreement

  def create
    @scanned_agreement = @agreement.build_scanned_agreement(scanned_agreement_params)
    if @scanned_agreement.save
      flash[:notice] = "Agreement uploaded!"
      @agreement.mark_active!
      redirect_to proposal_agreements_path(@agreement.proposal)
    else
      flash[:alert] = "Agreement could not be uploaded."
      redirect_to :back
    end
  end

  protected

  def scanned_agreement_params
    params.require(:scanned_agreement).permit(:agreement_id, :scan)
  end

end
