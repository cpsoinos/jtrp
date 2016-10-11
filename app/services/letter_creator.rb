class LetterCreator

  attr_reader :accounts

  def initialize(accounts)
    @accounts = accounts
  end

  def create
    accounts.each do |account|
      account.letters.create
    end
  end

end
