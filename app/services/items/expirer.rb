module Items
  class Expirer

    attr_reader :items

    def initialize(items)
      @items = items
    end

    def execute
      expire_items
    end

    private

    def expire_items
      items.map(&:mark_expired)
    end

  end
end
