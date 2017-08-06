class CompaniesController < ApplicationController
  before_action :require_internal, except: [:client_services, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :home, :about, :contact, :send_message]

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
      redirect_to about_path
    else
      flash[:error] = "Unable to save changes."
      redirect_back(fallback_location: root_path)
    end
  end

  def consignment_policies
    @title = "Consignment Policies"
  end

  def service_rate_schedule
    @title = "Service Rates"
  end

  def agent_service_rate_schedule
    @title = "Agent Service Rates"
  end

  def send_message
    if params[:photos]
      photos = PhotoCreator.new.create_multiple(photos: params[:photos], photo_type: 'submission')
    end
    Notifier.send_contact_us(params[:from_name], params[:email], params[:subject], params[:note], photos).deliver_later
    redirect_to root_path, notice: "Your message has been sent!"
  end

  protected

  def company_params
    params.require(:company).permit([
      :slogan, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :website, :logo, :description, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :name]).tap do |whitelisted|
      whitelisted[:hours_of_operation] = params[:company][:hours_of_operation]
    end
  end

  def build_todos
    @items = ItemsPresenter.new.todo.page(params[:page]).distinct
    @statements = StatementsPresenter.new.todo.distinct
    @agreements = AgreementsPresenter.new.todo.distinct
  end

  def build_js_metrics(presenter)
    gon.salesMetrics = presenter.build_json_for_sales
    gon.customerMetrics = presenter.build_json_for_customers
    gon.clientMetrics = presenter.build_json_for_clients
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
