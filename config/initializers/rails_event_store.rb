Rails.configuration.to_prepare do
  event_store = RailsEventStore::Client.new
  Rails.configuration.event_store = event_store

  event_store.subscribe(OrderLogger.new, [OrderCreated])
end
