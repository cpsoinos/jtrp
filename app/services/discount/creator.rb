class Discount::Creator

  attr_reader :discountable, :attrs

  def initialize(discountable)
    @discountable = discountable
    @attrs = attrs
  end

  def create(attrs)
    @attrs = attrs.to_hash
    massage_attrs
    create_discount
  end

  private

  def massage_attrs
    attrs.symbolize_keys!
    attrs[:remote_id] = attrs.delete(:id)
    attrs.delete(:orderRef)
    attrs.delete(:lineItemRef)
    attrs[:percentage] = format_percentage(attrs[:percentage])
    attrs[:amount_cents] = attrs.delete(:amount)
    attrs[:discountable] = discountable
  end

  def format_percentage(amt)
    amt.to_f / 100
  end

  def create_discount
    Discount.find_or_create_by(attrs)
  end

end
