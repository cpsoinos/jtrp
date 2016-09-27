class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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
    @categories = Category.primary.order(:name)
  end

  def find_categories_for_dropdown
    @categories_for_dropdown ||= Category.all.map do |category|
      [category.name, category.id]
    end
  end

  def require_internal
    if current_user.present?
      unless current_user.internal?
        redirect_to root_path, alert: "Sorry, you don't have permission to access this page!"
      end
    else
      redirect_to new_user_session_path, alert: "You must be logged in to access this page!"
    end
  end

  def require_internal_or_client
    unless current_user.present? && (current_user.internal? || current_user.account == @account)
      redirect_to new_user_session_path, alert: "You must be logged in to access this page!"
    end
  end

  def meta_tags
    @meta_tags = {
      site: "Just the Right Piece",
      og: og_meta_tags,
      twitter: twitter_meta_tags,
      fb: facebook_meta_tags,
      product: product_meta_tags
    }
  end

  def og_meta_tags
    return unless @item.present?
    {
      title:       "Found at #{@company.name}",
      description: "#{@item.description.titleize} - #{ActionController::Base.helpers.humanized_money_with_symbol(@item.listing_price)}",
      type:        'product',
      url:         item_url(@item),
      image:       @item.featured_photo.photo_url(client_hints: true, quality: "auto", fetch_format: :auto, width: :auto, dpr: "auto", effect: :improve),
      site_name:   @company.name,
      see_also:    (category_url(@item.try(:category)) if @item.category.present?)
    }
  end

  def facebook_meta_tags
    {
      admins: '1499856343665394',
      app_id: ENV['FACEBOOK_APP_ID']
    }
  end

  def product_meta_tags
    return unless @item.present?
    {
      category: @item.category.name,
      price:    ActionController::Base.helpers.humanized_money_with_symbol(@item.listing_price)
    }
  end

  def twitter_meta_tags
    return unless @item.present?
    {
      card: "summary_large_image",
      site: "@JtRP_furniture",
      title: "Found at #{@company.name}",
      description: "#{@item.description.titleize} - #{ActionController::Base.helpers.humanized_money_with_symbol(@item.listing_price)}",
      image: @item.featured_photo.photo_url(client_hints: true, quality: "auto", fetch_format: :auto, width: :auto, dpr: "auto", effect: :improve)
    }
  end

end
