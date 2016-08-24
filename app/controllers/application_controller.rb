class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :find_company
  before_filter :find_categories

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
    @categories = Category.all
  end

  def find_categories_for_dropdown
    @categories_for_dropdown ||= Category.all.map do |category|
      [category.name, category.id]
    end
  end

  def require_internal
    unless current_user.present? && current_user.internal?
      render status: :forbidden, text: "Forbidden fruit"
    end
  end

  def require_internal_or_client
    unless current_user.present? && (current_user.internal? || current_user.account == @account)
      render status: :forbidden, text: "Forbidden fruit"
    end
  end

  def meta_tags
    @meta_tags = {
      site: "Just the Right Piece",
      og: og_meta_tags
      # title: 'Member Login',
      # description: 'Member login page.',
      # keywords: 'Site, Login, Members',
    }
  end

  def og_meta_tags
    {
      title:    @item.description.titleize,
      type:     'product',
      url:      item_url(@item),
      image:    @item.featured_photo_url,
    }
  end

end
