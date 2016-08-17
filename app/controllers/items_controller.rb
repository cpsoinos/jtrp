class ItemsController < ApplicationController
  before_filter :find_clients, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit, :show, :index]
  before_filter :find_proposal, only: [:create, :batch_create]
  before_filter :find_job, only: :tags
  before_filter :require_internal, except: [:index, :show]
  before_filter :find_item, only: :show
  before_filter :meta_tags, only: :show

  def index
    @items = ItemsPresenter.new(params).filter
    @intentions = @items.pluck(:client_intention).uniq
    intentions_map
    @filter = params[:status].try(:capitalize)
    @type = params[:type]
  end

  def new
    @item = Item.new
  end

  def create
    @item = ItemCreator.new(@proposal).create(item_params)
    @proposal = @item.proposal
    @job = @proposal.job
    @account = @job.account
    respond_to do |format|
      if @item.persisted?
        format.html do
          flash[:notice] = "Item created"
          redirect_to account_job_proposal_sort_items_path(@account, @job, @proposal)
        end
        format.js do
          render :'proposals/add_item'
        end
      else
        format.html do
          flash[:alert] = "Item could not be saved"
          render :new
        end
        format.js do
          render nothing: true
        end
      end
    end
  end

  def batch_create
    find_proposal
    @archive = Archive.new
    @archive.update_attribute(:key, params[:key])
    @archive.save_and_process_items(@proposal)
    redirect_to edit_account_job_proposal_path(@proposal.account, @proposal.job, @proposal)
  end

  def csv_import
    @csv = ItemSpreadsheet.new
    @csv.update_attribute(:key, params[:key])
    @csv.save_and_process_items(current_user)
    redirect_to items_path
  end

  def show
    @child_item = @item.build_child_item
  end

  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
  end

  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if ItemUpdater.new(@item).update(item_params)
        format.js { render 'proposals/update_item_details' }
        format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
        format.json { respond_with_bip(@item) }
      else
        format.html do
          flash[:alert] = 'Could not update item.'
          redirect_to edit_account_job_proposal_item_path(@item.account, @item.job, @item.proposal, @item)
        end
        format.json { respond_with_bip(@item) }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    filter = @item.status
    if @item.destroy
      respond_to do |format|
        format.js do
          render 'proposals/remove_item'
        end
        format.html do
          flash[:notice] = "Item removed"
          redirect_to items_path(status: filter)
        end
      end
    else
      redirect_to :back
    end
  end

  def tag
    @item = Item.find(params[:item_id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "tag"
      end
    end
  end

  def tags
    @items = @job.items.filter(status: params[:status])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "tags", margin: { top: 5, bottom: 0, right: 5 }
      end
    end
  end

  protected

  def item_params
    params.require(:item).permit(:description, {photos: []}, {initial_photos: []}, {listing_photos: []}, :purchase_price, :asking_price, :listing_price, :sale_price, :sold_at, :minimum_sale_price, :condition, :category_id, :client_intention, :notes, :will_purchase, :will_consign, :account_item_number, :consignment_rate, :proposal_id, :parent_item_id)
  end

  def archive_params
    params.require(:item).permit(:archive)
  end

  def intentions_map
    @intentions_map = {
      "consign" => { display_name: "consigned", icon: "<i class='material-icons'>supervisor_account</i>", color: "secondary-primary" },
      "sell" => { display_name: "owned", icon: "<i class='material-icons'>store</i>", color: "complement-primary" },
      "donate" => { display_name: "will donate", icon: "<i class='fa fa-gift' aria-hidden='true'></i>", color: "secondary-darker" },
      "dump" => { display_name: "will dump", icon: "<i class='material-icons'>delete</i>", color: "complement-darker" },
      "undecided" => { display_name: "undecided", icon: "<i class='fa fa-question' aria-hidden='true'></i>", color: "primary-lighter" },
      "nothing" => { display_name: "client kept", icon: "<i class='material-icons'>weekend</i>", color: "primary-lighter" }
    }
  end

  def find_item
    @item = Item.find(params[:id])
  end

end
