class Item::Expirer

  attr_reader :item

  def expire!(items)
    items.map(&:mark_expired)
  end

end
