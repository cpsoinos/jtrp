class ProposalsController < ApplicationController
  before_filter :find_accounts, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit]
  before_filter :require_internal, except: [:show]

  def new
    @proposal = Proposal.new
    @client = Client.new
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if @proposal.save
      redirect_to edit_proposal_path(@proposal)
    else
      flash[:alert] = @proposal.errors.full_messages.uniq.join
      @client = Client.new
      render :new
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
    @account = @proposal.account
    @client = @account.primary_contact
    @items = @proposal.items
  end

  def edit
    @proposal = Proposal.find(params[:id])
    @account = @proposal.account
    @item = @proposal.items.new
    @items = @proposal.items
    gon.items = build_json_for_items
    gon.proposalId = @proposal.id
  end

  def details
    @proposal = Proposal.find(params[:proposal_id])
    @items = @proposal.items
  end

  def response_form
    @proposal = Proposal.find(params[:proposal_id])
    @account = @proposal.account
    @client = @account.primary_contact
    @items = @proposal.items.order(:id)
  end

  protected

  def proposal_params
    params.require(:proposal).permit([:account_id, :created_by_id])
  end

  def build_json_for_items
    items_for_list = @account.items.potential.where(proposal_id: nil)
    items_for_list.map do |item|
      {
        text: item.description,
        value: item.id,
        selected: false,
        imageSrc: (item.initial_photos.present? ? item.initial_photos.first.photo_url(:thumb) : Photo.default_url)
      }
    end.to_json
  end

end
