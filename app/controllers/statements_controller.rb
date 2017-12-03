class StatementsController < ApplicationController
  before_action :find_account, except: :statements_list
  before_action :require_internal, except: :show

  def index
    @statements = @account.statements
    @title = "#{@account.full_name} - Statements"
  end

  def statements_list
    @statements = Statement.includes(account: :primary_contact).all
    @title = "Consignment Statements"
  end

  def show
    @statement = Statement.find(params[:id])
    require_token; return if performed?
    @check = @statement.checks.first
    @client = @account.client
    @title = "#{@account.full_name} - Consigned Sales"
    @hide_raised = true if @statement.pdf.present?
  end

  def update
    @statement = Statement.find(params[:id])
    if Statement::Updater.new(@statement).update(statement_params)
      @statement.create_activity(:update, owner: current_user)
      respond_to do |format|
        format.js do
          @message = "Statement updated!"
        end
      end
    end
  end

  def gather_items
    @statement = Statement.find(params[:statement_id])
    Statements::ItemGatherer.new(@statement, @account).execute
    redirect_to account_statement_path(@account, @statement), notice: "Gathered consigned items for #{@account.full_name} that sold in #{@statement.date.last_month.strftime("%B, %Y")}"
  end

  def send_email
    @statement = Statement.find(params[:statement_id])
    TransactionalEmailJob.perform_later(@statement, current_user, @statement.account.primary_contact, "statement", params)
    redirect_back(fallback_location: root_path, notice: "Email sent to client!")
  end

  protected

  def statement_params
    params.require(:statement).permit(:status, :check_number, :paid_manually)
  end

  def require_token
    unless (params[:token] == @statement.token) || (@statement.created_at < DateTime.parse("October 29, 2016"))
      require_internal
    end
  end

end
