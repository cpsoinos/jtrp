class ItemsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    if params[:status]
      Item.send(params[:status])
    else
      Item.all
    end
  end

end
