class ItemsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Item.filter(params.slice(:status, :type))
  end

end
