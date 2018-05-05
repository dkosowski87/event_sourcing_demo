class OrdersController < ApplicationController
  def create
    command = CreateOrder.new(order_params)
    command.validate!

    handler = CreateOrderHandler.new(number_generator: NumberGenerator.new)
    handler.call(command)

    redirect_to Order.find(command.order_id)
  end

  private

  def order_params
    params.permit(:order_id, :customer_id)
  end
end
