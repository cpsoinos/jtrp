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
  end

  def update
    @statement = Statement.find(params[:id])
    if StatementUpdater.new(@statement).update(statement_params)
      respond_to do |format|
        format.js do
          @message = "Statement updated!"
        end
      end
    end
  end

  def send_email
    @statement = Statement.find(params[:statement_id])
    TransactionalEmailJob.perform_later(@statement, current_user, @statement.account.primary_contact, "statement", params[:note])
    redirect_to :back, notice: "Email sent to client!"
  end

  protected

  def statement_params
    params.require(:statement).permit(:status, :check_number)
  end

end
