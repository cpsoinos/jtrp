class LetterCreator

  attr_reader :object, :account

  def initialize(object)
    @object = object
    @account = object.account
    @type = type
  end

  def create_letter(type)
    account.letters.create(type: type)
  end

end
