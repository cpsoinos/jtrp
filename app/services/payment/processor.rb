class Payment::Processor

  attr_reader :payment

  def initialize(payment)
    @payment = payment
  end

  def process
    update_payment
    update_order
  end

  private

  def update_payment
    payment.update(processed_attrs)
  end

  def processed_attrs
    {
      order: order,
      amount_cents: remote_object.amount,
      tax_amount_cents: remote_object.taxAmount
    }
  end

  def remote_object
    @_remote_object ||= payment.remote_object
  end

  def order
    @_order ||= payment.order || Order.find_or_create_by(remote_id: remote_object.order.id)
  end

  def update_order
    order.process_webhook
  end

end
