class ProposalsController < ApplicationController
  before_filter :require_internal, except: [:show]

  def new
    @proposal = Proposal.new
    @clients = clients
    @items = items
  end

  private

  def clients
    @clients = User.client.map do |client|
      [client.full_name, client.id]
    end
  end

  def items
    @items = Item.potential.map do |item|
      [item.name, item.id]
    end
  end

end
