class EventCreator

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def create(verb)
    Event.create(object: object, verb: verb, user: object.updater)
  end

end
