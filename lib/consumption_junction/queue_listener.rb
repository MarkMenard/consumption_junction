class ConsumptionJunction::QueueListener
  include Celluloid

  attr_accessor :factory, :connection, :channel, :consumer
  attr_accessor :listener_thread, :message_processor, :queue_name, :queue
  
  def initialize (queue_name, message_processor)
    self.queue_name = queue_name
    self.message_processor = message_processor
  end
  
  def start
    start_queue
    listen_for_messages
  end
  
  def start_queue
    
    self.factory = ConsumptionJunction::ConnectionFactory.new
    factory.host = "localhost"

    self.connection = factory.new_connection

    self.channel = connection.create_channel

    channel.queue_declare(queue_name, true, false, false, nil)
    channel.basic_qos(1)

  end
  
  def listen_for_messages
    self.consumer = ConsumptionJunction::QueueingConsumer.new(channel)
    channel.basic_consume(queue_name, false, consumer);

    self.listener_thread = Thread.new do
      while true
        delivery = consumer.next_delivery
        message = java.lang.String.new(delivery.body)
        message.process_message(message)
        channel.basic_ack(delivery.envelope.delivery_tag, false);
      end
    end
  end

  def pop_message (ack = true)
    queue.pop(:ack => ack)
  end
  
end
