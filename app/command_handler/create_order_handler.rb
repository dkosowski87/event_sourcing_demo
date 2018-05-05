class CreateOrderHandler
  def initialize(number_generator:)
    @number_generator = number_generator
  end

  def call(command)
    aggregate = Order.new(command.order_id)

    aggregate.load

    order_number = generate_order_number
    aggregate.create(order_number, command.customer_id)

    aggregate.store
  end

  private

  attr_reader :number_generator

  def generate_order_number
    number_generator.call
  end
end
