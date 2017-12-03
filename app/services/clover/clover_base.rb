module Clover
  class CloverBase
    TIME_ATTRIBUTES = [
      :createdTime,
      :modifiedTime,
      :orderClientCreatedTime,
      :clientCreatedTime
    ]
    MONEY_ATTRIBUTES = [
      :amount,
      :taxAmount,
      :cashTendered,
      :cost,
      :price,
      :total
    ]
    OBJECT_ATTRIBUTES = [
      :lineItems,
      :discounts,
      :payments,
      :itemStock,
      :item,
      :order
    ]

    def initialize(attrs)
      attrs.deep_symbolize_keys!
      attrs.each do |key, value|
        attrs[key] = format_time(value) if key.in?(TIME_ATTRIBUTES)
        attrs[key] = format_money(value) if key.in?(MONEY_ATTRIBUTES)
        if key.in?(OBJECT_ATTRIBUTES)
          klass = begin
            if key === :item
              Clover::Inventory
            else
              "Clover::#{key.to_s.singularize.camelize}".constantize
            end
          end
          elements = value.try(:dig, :elements) || value.try(:elements)
          if elements
            attrs[key] = elements.map do |el|
              klass.new(el)
            end
          else
            attrs[key] = klass.new(value)
          end
        end
      end
      set_attributes(attrs)
    end

    def self.base_url
      "#{ENV['CLOVER_API_URL']}/v3/merchants/#{ENV['CLOVER_MERCHANT_ID']}"
    end

    def self.headers
      {
        Authorization: "Bearer #{auth_token}",
        content_type: :json
      }
    end

    def self.auth_token
      @_auth_token ||= begin
        Admin.first.oauth_accounts.clover.first.try(:access_token) ||
          ENV['CLOVER_API_TOKEN']
      end
    end

    private

    def format_money(amount)
      Money.new(amount)
    end

    def format_time(timestamp)
      Time.at(timestamp / 1000).to_datetime
    end

    def set_attributes(attrs)
      attrs.each do |key, val|
        begin
          self.send(:"#{key}=", val)
        rescue
        end
      end
    end

  end
end
