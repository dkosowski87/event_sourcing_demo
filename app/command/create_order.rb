class CreateOrder
  include ActiveModel::Model
  include ActiveModel::Validations

  class ValidationFailed < StandardError; end

  attr_accessor :order_id
  attr_accessor :customer_id

  validates :order_id, presence: true
  validates :customer_id, presence: true

  def validate!
    raise ValidationFailed, errors unless valid?
    true
  end

  def persisted?
    false
  end
end
