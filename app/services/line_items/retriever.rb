module LineItems
  class Retriever

    attr_reader :line_item

    def initialize(line_item)
      @line_item = line_item
    end

    def execute
      retrieve_local_item
    end

    private

    def retrieve_local_item
      item = find_item_by_remote_id
      item ||= find_item_by_token
      item
    end

    def find_item_by_remote_id
      remote_id = line_item.try(:item).try(:id)
      Item.find_by(remote_id: remote_id)
    end

    def find_item_by_token
      token = line_item.try(:itemCode)
      token ||= line_item.try(:alternateName)
      Item.find_by(token: token)
    end

  end
end
