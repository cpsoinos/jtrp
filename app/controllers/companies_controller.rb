class CompaniesController < ApplicationController
  before_filter :require_internal, except: [:client_services, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :home, :about, :contact, :send_message]

  layout :resolve_layout

  def show
    @navtab = "dashboard"
    @title = "Dashboard"
    build_todos
    presenter = MetricsPresenter.new
    build_js_metrics(presenter)
    @metrics = presenter.build_metrics
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order(created_at: :desc).page(params[:page]).per(5)
  end

  def home
    @featured_items = Item.active.includes(:category).joins(:photos).limit(3).order("RANDOM()")
    @title = "Home"
  end

  def about
    @title = "About Us"
  end

  def contact
    @title = "Contact Us"
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
    @title = "Client Services"
  end

  def consignment_policies
    @title = "Consignment Policies"
  end

  def service_rate_schedule
    @title = "Service Rate Schedule"
  end

  def agent_service_rate_schedule
    @title = "Service Rate Schedule for Agents"
  end

  def send_message
    TransactionalEmailJob.perform_later(@company, current_user, @company.primary_contact, "contact", params)
    redirect_to root_path, notice: "Your message has been sent!"
  end

  protected

  def company_params
    params.require(:company).permit([
      :slogan, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :website, :logo, :description, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :bootsy_image_gallery_id, :name]).tap do |whitelisted|
      whitelisted[:hours_of_operation] = params[:company][:hours_of_operation]
    end
  end

  def build_todos
    @items = ItemsPresenter.new.todo.page(params[:page]).uniq
    @statements = StatementsPresenter.new.todo.uniq
    @agreements = AgreementsPresenter.new.todo.uniq
  end

  def build_js_metrics(presenter)
    gon.salesMetrics = presenter.build_json_for_sales
    gon.customerMetrics = presenter.build_json_for_customers
    gon.clientMetrics = presenter.build_json_for_clients
  end

  def resolve_layout
    if action_name.in?(%w(home about contact client_services consignment_policies service_rate_schedule agent_service_rate_schedule edit))
      "ecommerce"
    else
      "application"
    end
  end

  def find_categories
    @categories ||= begin
      if current_user.try(:internal?)
        Category.all.order(:name)
      else
        Category.categorized.order(:name)
      end
    end
  end

end
