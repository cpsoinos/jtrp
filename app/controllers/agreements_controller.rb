class AgreementsController < ApplicationController
  before_action :require_internal, except: [:show, :update]
  before_action :find_proposal, only: [:create, :send_email]
  before_action :find_job, only: [:create]
  before_action :find_account, only: [:create]
  before_action :pull_intentions, only: :create

  def index
    @proposal = Proposal.includes(:account, :job, :agreements, account: :primary_contact).find(params[:proposal_id])
    @job = @proposal.job
    @account = @proposal.account
    @client = @proposal.account.primary_contact
    @agreements = @proposal.agreements
    @title = "#{@job.name} - Proposal #{@proposal.id} - Agreements"
  end

  def show
    @agreement = Agreement.find(params[:id])
    require_token; return if performed?
    @proposal = @agreement.proposal
    @job = @proposal.job
    @account = @agreement.proposal.job.account
    @client = @account.primary_contact
    @items = @agreement.items
    @title = "#{@job.name} - Proposal #{@proposal.id} - #{@agreement.humanized_agreement_type}"
    @hide_raised = true if @agreement.pdf.present?
  end

  def edit
    @agreement = Agreement.find(params[:id])
    @proposal = @agreement.proposal
    @job = @proposal.job
    @account = @agreement.proposal.job.account
    @client = @account.primary_contact
    @agreements = [@agreement]
    @items = @agreement.items
    @title = "#{@job.name} - Proposal #{@proposal.id} - #{@agreement.humanized_agreement_type}"
  end

  def agreements_list
    @agreements = AgreementsPresenter.new(params).filter
    @intentions = @agreements.pluck(:agreement_type).uniq
    @title = "Agreements List"
  end

  def create
    @client = @account.primary_contact
    @agreements = Agreements::Creator.new(current_user).create(@proposal)
    @agreements.each do |agreement|
      agreement.create_activity(:create, owner: current_user)
    end
    redirect_to account_job_proposal_agreements_path(@account, @job, @proposal)
  end

  def update
    @agreement = Agreement.find(params[:id])
    # if Agreements::Updater.new(@agreement).update(agreement_params.merge(updated_by: current_user))
    if @agreement.update(agreement_params.merge(updated_by: current_user))
      @agreement.create_activity(:update, owner: current_user)
      respond_to do |format|
        format.html do
          if @agreement.active? || @agreement.mark_active # will return if does not meet requirements
            flash[:notice] = "Agreement updated!"
            redirect_to account_job_proposal_agreement_path(@agreement.account, @agreement.job, @agreement.proposal, @agreement)
          else
            flash[:alert] = "Could not update agreement."
            redirect_back(fallback_location: root_path)
          end
        end
        format.js do
          @role = params[:role]
        end
        format.json { respond_with_bip(@agreement) }
      end
    end
  end

  def send_email
    @agreement = Agreement.find(params[:agreement_id])
    if @agreement.potential?
      Notifier.send_agreement(@agreement, params[:note]).deliver_later
    else
      @agreement.deliver_to_client
    end
    redirect_back(fallback_location: root_path, notice: "Email sent to client!")
  end

  def activate_items
    @agreement = Agreement.find(params[:agreement_id])
    @agreement.items.map(&:mark_active)
    redirect_back(fallback_location: root_path, notice: "Items are marked active!")
  end

  def deactivate
    @agreement = Agreement.find(params[:agreement_id])
    @agreement.items.active.map(&:mark_inactive)
    if @agreement.mark_inactive
      redirect_back(fallback_location: root_path, notice: "Agreement deactivated.")
    else
      redirect_back(fallback_location: root_path, alert: "Error. Contact support.")
    end
  end

  def tag
    @agreement = Agreement.find(params[:agreement_id])
    @agreement.tag_list.add(params[:tag])
    if @agreement.save
      respond_to do |format|
        format.js do
          @message = "Agreement tagged as unexpireable."
          render 'letters/create'
        end
      end
    end
  end

  def regenerate_pdf
    @agreement = Agreement.find(params[:agreement_id])
    @agreement.save_as_pdf
    flash[:notice] = "Generating new PDF... refresh the page in a moment to see changes."
    redirect_to agreement_path(@agreement)
  end

  protected

  def agreement_params
    params.require(:agreement).permit(:manager_agreed, :manager_agreed_at, :client_agreed, :client_agreed_at, :service_charge, :check_number, :pdf, :pdf_pages)
  end

  def pull_intentions
    @intentions = @proposal.items.pluck(:client_intention).uniq
  end

  private

  def require_token
    unless (params[:token] == @agreement.token) || (@agreement.created_at < DateTime.parse("October 29, 2016"))
      require_internal
    end
  end

end
