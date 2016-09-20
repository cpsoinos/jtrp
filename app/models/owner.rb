class Owner < Account

  def items
    Item.owned
  end

end
