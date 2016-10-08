class ItemExpirer

  attr_reader :item

  def expire!(items)
    items.map(&:mark_expired)
  end

end
