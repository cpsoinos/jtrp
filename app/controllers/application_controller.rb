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

end
