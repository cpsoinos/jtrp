module Items
  class Expirer

    attr_reader :item

    def expire!(items)
      items.map(&:mark_expired)
    end

  end
end
