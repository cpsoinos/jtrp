class CompaniesController < ApplicationController
  layout :resolve_layout
  before_filter :require_internal, except: [:client_services, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :home, :about, :contact]

  def show
    build_todos
    @metrics = {
      owned_count: Item.owned.count,
      consigned_count: Item.consigned.count,
      thirty_day_revenue: Order.thirty_day_revenue,
      owed_to_consignors: Item.consigned.sold.where("items.sold_at >= ?", 30.days.ago).sum(:sale_price_cents) / 2
    }
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

  def about
  end

  def contact
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

  def send_email
    TransactionalEmailJob.perform_later(@company, current_user, @company.primary_contact, "contact", params)
    redirect_to root_path, notice: "Your message has been sent!"
  end

  protected

  def company_params
    params.require(:company).permit([:slogan, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :website, :logo, :description, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :bootsy_image_gallery_id])
  end

  def build_todos
    @items = ItemsPresenter.new.todo.page(params[:page])
    @statements = StatementsPresenter.new.todo
    @agreements = AgreementsPresenter.new.todo
    @todos = @agreements | @statements | @items
  end

  def resolve_layout
    if action_name.in?(%w(home about contact client_services consignment_policies service_rate_schedule agent_service_rate_schedule))
      "ecommerce"
    else
      "application"
    end
  end

end
