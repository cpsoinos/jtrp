module LineItems
  class Retriever

    attr_reader :line_item

    def initialize(line_item)
      @line_item = line_item
    end

    def execute
      find_item_by_remote_id
    end

    private

    def find_item_by_remote_id
      remote_id = line_item.try(:item).try(:id)
      Item.find_by(remote_id: remote_id)
    end

  end
end
