class LettersController < ApplicationController
  before_filter :find_account

  def index
    @letters = @account.letters
  end

  def show
    @letter = Letter.find(params[:id])
  end

end
