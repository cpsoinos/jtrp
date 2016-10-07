class StatementsController < ApplicationController
  before_filter :find_account
  before_filter :require_internal, except: :show

  def index
    require_internal
    @statements = @account.statements
  end

  def show
    @statement = Statement.find(params[:id])
    @client = @account.client
    @job = @statement.job
  end

  def send_email
    @statement = Statement.find(params[:statement_id])
    TransactionalEmailJob.perform_later(@statement, current_user, @statement.account.primary_contact, "statement", params[:note])
    redirect_to :back, notice: "Email sent to client!"
  end

end
