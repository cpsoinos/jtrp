class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  force_ssl if: :ssl_configured?
  protect_from_forgery with: :exception
  before_filter :find_company
  before_filter :find_categories
  before_filter :meta_tags

  def find_company
    @company ||= Company.find_by(name: "Just the Right Piece")
  end

  def find_category
    @category ||= Category.find(params[:category_id])
  end

  def find_proposal
    if params[:proposal_id]
      @proposal ||= Proposal.find(params[:proposal_id])
    end
  end

  def find_clients
    @clients ||= Client.all
  end

  def find_client
    @client ||= Client.find(params[:client_id])
  end

  def find_accounts
    @accounts ||= Account.all
  end

  def find_account
    @account = Account.find(params[:account_id])
  end

  def find_job
    @job = Job.find(params[:job_id])
  end

  def find_agreement
    @agreement ||= Agreement.find(params[:agreement_id])
  end

  def find_categories
    @categories = Category.categorized.order(:name)
  end

  def find_categories_for_dropdown
    @categories_for_dropdown ||= @categories.pluck(:name, :id)
  end

  def require_internal
    if current_user.present?
      unless current_user.internal?
        flash[:alert] = "Sorry, you don't have permission to access this page!"
        redirect_to root_path and return
      end
    else
      flash[:alert] = "You must be logged in to access this page!"
      redirect_to new_user_session_path and return
    end
    return true
  end

  def require_internal_or_client
    unless current_user.present? && (current_user.internal? || current_user.account == @account)
      redirect_to new_user_session_path, alert: "You must be logged in to access this page!"
    end
  end

  def meta_tags
    @meta_tags = {
      site: @company.name,
      title: @item.present? ? @item.description.titleize : @company.name,
      description: @company.meta_description,
      og: og_meta_tags,
      twitter: twitter_meta_tags,
      fb: facebook_meta_tags,
      product: product_meta_tags
    }
  end

  def og_meta_tags
    if @item.present?
      {
        title:       "#{@item.description.titleize}",
        description: "Found at #{@company.name} - #{ActionController::Base.helpers.humanized_money_with_symbol(@item.listing_price)}",
        type:        "product",
        url:         item_url(@item),
        image:       @item.featured_photo.photo_url(client_hints: true, quality: "auto", fetch_format: :auto, width: :auto, dpr: "auto", effect: :improve),
        site_name:   @company.name,
        see_also:    (category_url(@item.try(:category)) if @item.category.present?)
      }
    else
      {
        title:       @company.name,
        description: @company.meta_description,
        type:        "website",
        url:         @company.website,
        image:       @company.logo.url
      }
    end
  end

  def facebook_meta_tags
    {
      admins:       "1499856343665394",
      app_id:       ENV['FACEBOOK_APP_ID']
    }
  end

  def product_meta_tags
    return unless @item.present?
    {
      category: @item.try(:category).try(:name),
      price: {
        amount: @item.listing_price,
        currency: "USD"
      }
    }
  end

  def twitter_meta_tags
    return unless @item.present?
    {
      card:         "summary_large_image",
      site:         "@#{@company.twitter_account}",
      title:        "#{@item.description.titleize}",
      description:  "Found at #{@company.name} - #{ActionController::Base.helpers.humanized_money_with_symbol(@item.listing_price)}",
      image:        @item.featured_photo.photo_url(client_hints: true, quality: "auto", fetch_format: :auto, width: :auto, dpr: "auto", effect: :improve)
    }
  end

  def ssl_configured?
    Rails.env.production? && controller_name != 'webhooks'
  end

end
