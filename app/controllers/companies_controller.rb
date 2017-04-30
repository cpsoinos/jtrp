class CompaniesController < ApplicationController
  layout :resolve_layout
  before_filter :require_internal, except: [:client_services, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :home, :about, :contact, :send_message]

  def show
    @navtab = 'dashboard'
    build_todos
    gon.salesMetrics = build_json_for_sales
    gon.customerMetrics = build_json_for_customers
    gon.clientMetrics = build_json_for_clients
    @metrics = {
      owned_count: Item.owned.count,
      consigned_count: Item.consigned.count,
      potential_count: Item.potential.count,
      thirty_day_revenue: Order.thirty_day_revenue,
      owed_to_consignors: Item.consigned.sold.where("items.sold_at >= ?", 30.days.ago).sum(:sale_price_cents) / 2,
      sales_change: (((this_week_sales - last_week_sales) / this_week_sales) * 100).round(2),
      customers_change: (((this_week_customers - last_week_customers) / this_week_customers) * 100).round(2),
      clients_change: (((this_month_clients - last_month_clients) / this_month_clients) * 100).round(2)
    }
    @title = "Dashboard"
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order(created_at: :desc).page(params[:page]).per(5)
  end

  def home
    @featured_items = Item.active.joins(:photos).limit(10).order("RANDOM()")
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

  def build_json_for_sales
    {
      labels: day_labels,
      series: sales_series
    }.to_json
  end

  def build_json_for_customers
    {
      labels: day_labels,
      series: customer_series
    }.to_json
  end

  def build_json_for_clients
    {
      labels: month_labels,
      series: client_series
    }.to_json
  end

  def day_labels
    @_day_labels ||= [6, 5, 4, 3, 2, 1, 0].map { |d| d.days.ago.in_time_zone('Eastern Time (US & Canada)').strftime("%a") }
  end

  def month_labels
    @_month_labels ||= [5, 4, 3, 2, 1, 0].map { |d| d.months.ago.in_time_zone('Eastern Time (US & Canada)').strftime("%b") }
  end

  def sales_series
    @_sales_series ||= [6, 5, 4, 3, 2, 1, 0].map { |d| SalesMetrics.new(d.days.ago.in_time_zone('Eastern Time (US & Canada)')).daily_sales }
  end

  def customer_series
    @_customer_series ||= [6, 5, 4, 3, 2, 1, 0].map { |d| CustomerMetrics.new(d.days.ago.in_time_zone('Eastern Time (US & Canada)')).daily_customers }
  end

  def client_series
    @_client_series ||= [5, 4, 3, 2, 1, 0].map { |d| ClientMetrics.new(d.months.ago.in_time_zone('Eastern Time (US & Canada)')).daily_clients }
  end

  def last_week_sales
    @_last_week_sales ||= Payment.where(created_at: 2.weeks.ago..1.week.ago).sum(:amount_cents).to_f
  end

  def this_week_sales
    @_this_week_sales ||= Payment.where(created_at: 1.weeks.ago..DateTime.now).sum(:amount_cents).to_f
  end

  def last_week_customers
    @_last_week_customers ||= Customer.where(created_at: 2.weeks.ago..1.week.ago).count.to_f
  end

  def this_week_customers
    @_this_week_customers ||= Customer.where(created_at: 1.weeks.ago..DateTime.now).count.to_f
  end

  def last_month_clients
    @_last_month_clients ||= Client.where(created_at: 2.months.ago..1.month.ago).count.to_f
  end

  def this_month_clients
    @_this_month_clients ||= Client.where(created_at: 1.month.ago..DateTime.now).count.to_f
  end

end
