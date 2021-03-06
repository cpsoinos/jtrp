class LettersController < ApplicationController
  before_action :find_account, except: :create
  before_action :require_internal, except: :show

  def index
    @letters = @account.letters
    @title = "Letters for #{@account.full_name}"
  end

  def show
    @letter = Letter.find(params[:id])
    @title = "#{@account.full_name} - #{@letter} Letter"
    require_token; return if performed?
  end

  def create
    @agreement = Agreement.find(params[:agreement_id])
    @letter = @agreement.letters.new(letter_params)
    respond_to do |format|
      format.js do
        if @letter.save and @letter.deliver_to_client
          @letter.create_activity(:create, owner: current_user)
          @message = "Email and letter queued for delivery"
        else
          @message = @letter.errors.full_messages
        end
      end
    end
  end

  def deliver
    @letter = Letter.find(params[:id])
  end

  private

  def letter_params
    params.require(:letter).permit(:category, :note)
  end

  def require_token
    unless params[:token] == @letter.token
      require_internal
    end
  end

end
