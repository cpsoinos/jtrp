class CompaniesController < ApplicationController
  before_filter :require_internal, except: [:client_services, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :home]

  def show
    @metrics = {
      owned_count: Item.owned.count,
      consigned_count: Item.consigned.count,
      thirty_day_revenue: Order.all.sum(:amount_cents) / 100,
      owed_to_consignors: Item.consigned.sold.where("items.sold_at >= ?", 30.days.ago).sum(:sale_price_cents) / 2
    }
    @items = ItemsPresenter.new.todo.page(params[:page])
    @featured_photo = Photo.new(photo_type: 'featured_photo')

    if current_user.admin?
      @csv = ItemSpreadsheet.new
      @uploader = @csv.csv
      @uploader.success_action_redirect = items_csv_import_url
    end
  end

  def home
    @featured_photos = Photo.featured
  end

  def edit
  end

  def update
    if @company.update(company_params)
      flash[:notice] = "Changes saved!"
      redirect_to client_services_path
    else
      flash[:error] = "Unable to save changes."
      redirect_to :back
    end
  end

  def client_services
  end

  def consignment_policies
  end

  def service_rate_schedule
  end

  def agent_service_rate_schedule
  end

  protected

  def company_params
    params.require(:company).permit([:slogan, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :website, :logo, :description, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :bootsy_image_gallery_id])
  end

end
