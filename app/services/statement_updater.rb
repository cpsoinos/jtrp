class StatementUpdater

  attr_reader :statement, :attrs

  def initialize(statement)
    @statement = statement
  end

  def update(attrs)
    @attrs = attrs
    handle_manual_payment
    statement.pay if attrs[:status] == "paid"
    statement.update(attrs)
  end

  private

  def handle_manual_payment
    return unless attrs[:paid_manually].present?
    attrs.delete(:paid_manually)
    statement.tag_list += "paid_manually"
    statement.save
  end

end
