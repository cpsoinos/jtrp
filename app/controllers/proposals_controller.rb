class ProposalsController < ApplicationController
  before_action :find_categories, except: [:sort_items]
  before_action :find_account, except: [:send_email, :notify_response]
  before_action :find_job, except: [:new, :send_email, :notify_response]
  before_action :require_internal, except: [:show, :notify_response]

  def new
    @proposal = Proposal.new
    find_job if params[:job_id]
    @jobs = @account.jobs
    if @jobs.empty?
      redirect_to new_account_job_path(@account)
    end
    gon.jobs = build_json_for_jobs
  end

  def create
    @proposal = @job.proposals.new(created_by: current_user)
    if @proposal.save
      @proposal.create_activity(:create, owner: current_user)
      redirect_to edit_account_job_proposal_path(@account, @job, @proposal)
    else
      flash[:alert] = @proposal.errors.full_messages.uniq.join
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
    require_token; return if performed?
    @client = @account.primary_contact
    @items = @proposal.items.order(:account_item_number)
    @title = "Proposal for #{@proposal.account.full_name}"
    respond_to do |format|
      format.html do
        if @client.nil?
          flash[:alert] = "This account needs a primary contact!"
          redirect_to new_client_path(account_id: @account.id)
        end
      end
      format.pdf do
        send_data(PdfGenerator.new(@proposal).render_pdf, :type => "application/pdf", :disposition => 'inline')
      end
    end
  end

  def index
    @proposals = @job.proposals
  end

  def send_email
    @proposal = Proposal.find(params[:proposal_id])
    TransactionalEmailJob.perform_later(@proposal, @company.primary_contact, @proposal.account.primary_contact, "proposal", params)
    redirect_back(fallback_location: root_path, notice: "Email sent to client!")
  end

  def notify_response
    @proposal = Proposal.find(params[:proposal_id])
    TransactionalEmailJob.perform_later(@proposal, @proposal.account.primary_contact, @company.primary_contact, "notification", params)
    redirect_back(fallback_location: root_path, notice: "Thank you! We've been notified of your responses.")
  end

  def edit
    @proposal = Proposal.includes(items: :photos).find(params[:id])
    @item = @proposal.items.new
    gon.proposalId = @proposal.id
    @title = "Proposal for #{@proposal.account.full_name} - Upload Photos"
  end

  def sort_photos
    @proposal = Proposal.find(params[:proposal_id])
    @photos = @proposal.photos.order(:position)
    @title = "Proposal for #{@proposal.account.full_name} - Sort Photos"
  end

  def sort_items
    @categories = Category.order(:name)
    @proposal = Proposal.find(params[:proposal_id])
    @photos = @proposal.photos.where(item_id: nil).order(:position)
    @item = @proposal.items.new
    @title = "Proposal for #{@proposal.account.full_name} - Sort Items"
  end

  def details
    @proposal = Proposal.find(params[:proposal_id])
    @items = @proposal.items.order(:account_item_number)
    @title = "Proposal for #{@proposal.account.full_name} - Item Details"
  end

  protected

  def proposal_params
    params.require(:proposal).permit([:job_id, :created_by_id])
  end

  def build_json_for_jobs
    @jobs.map do |job|
      {
        text: job.name,
        value: job.id,
        selected: false,
        imageSrc: job.maps_url
      }
    end.to_json
  end

  private

  def require_token
    unless (params[:token] == @proposal.token) || (@proposal.created_at < DateTime.parse("October 29, 2016"))
      require_internal
    end
  end

end
