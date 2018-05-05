class OrderLogger
  def call(event)
    Rails.logger.info 'Order created ...'
  end
end
