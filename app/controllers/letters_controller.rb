class LettersController < ApplicationController
  before_filter :find_account
  before_filter :require_internal, except: :show

  def index
    @letters = @account.letters
  end

  def show
    @letter = Letter.find(params[:id])
    require_token; return if performed?
  end

  private

  def require_token
    unless params[:token] == @letter.token
      require_internal
    end
  end

end
