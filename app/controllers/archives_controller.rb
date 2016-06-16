class ArchivesController < ApplicationController

  # def new
  #   @uploader = User.new.avatar
  #   @uploader.success_action_redirect = new_user_url
  # end

  def create
    find_proposal
    @archive = Archive.new(archive_params)
    if @archive.save_and_process_items(@proposal)
      flash[:notice] = "Items being processed"
      redirect_to edit_account_job_proposal_path(@proposal.account, @proposal.job, @proposal)
    else
      redirect_to :back
    end
  end

  protected

  def archive_params
    params.require(:archive).permit(:key, :proposal_id)
  end

end
