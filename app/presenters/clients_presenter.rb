class ClientsPresenter

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def filter
    # if params[:status]
    #   User.client.joins(proposals: :items).merge(Item.send(params[:status]))
    # end
  end

end
