class ItemsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    if params[:state]
      Item.send(params[:state])
    else
      Item.all
    end
  end

end
