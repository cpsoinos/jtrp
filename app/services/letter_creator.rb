class LetterCreator

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def create_letter(category)
    object.letters.create(category: category)
  end

end
