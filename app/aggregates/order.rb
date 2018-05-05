class Order
  class AlreadyCreated < StandardError; end

  def initialize(id)
    @id = id
    @stream_name = "#{self.class.name}$#{id}"
    @state = :draft
  end

  def create(order_number, customer_id)
    raise AlreadyCreated unless state == :draft
    apply OrderCreated.create(id, order_number, customer_id)
  end

  def apply(event, published = false)
    @customer_id = event.customer_id
    @order_number = event.order_number
    @state = :created

    @unpublished_events << event unless published
  end

  def load
    events = read_events_from_stream(stream_name)
    rebuild(events)
    unpublished_events
  end

  def store
    event_store.publish_events(unpublished_events, stream_name: stream_name)
  end

  private

  attr_reader :stream_name
  attr_reader :id, :customer_id, :order_number, :state

  def read_events_from_stream(stream_name)
    event_store.read_stream_events_forward(stream_name)
  end

  def rebuild(events)
    events.each { |event| apply(event, true) } if events
  end

  def unpublished_events
    @unpublished_events ||= []
  end

  def event_store
    @event_store ||= Rails.configuration.event_store
  end
end
