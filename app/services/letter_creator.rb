class LetterCreator

  attr_reader :object, :account

  def initialize(object)
    @object = object
    @account = object.account
  end

  def create_letter(category)
    account.letters.create(category: category)
  end

end
