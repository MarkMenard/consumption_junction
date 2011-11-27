class ConsumptionJunction::EmWorkerSubscription
  
  attr_accessor :channel, :worker_config
  
  def self.create_subscription (channel, worker_config)
    subscription = self.new(channel, worker_config)
    subscription.create_subscription
    subscription
  end
  
  def initialize (channel, worker_config)
    @channel = channel
    @worker_config = worker_config
  end
  
  def create_subscription
    consumer.consume.on_delivery do |header, payload|
      EventMachine.defer(operation(payload), callback(header))
    end
  end
  
  def consumer
    @consumer ||= AMQP::Consumer.new(channel, queue) # , '', false, !worker_config.ack)
  end

  def queue
    @queue ||= channel.queue(worker_config.queue, :durable => true)
  end
  
  def message_processor_supervisor
    @message_processor_supervisor ||= ConsumptionJunction::MessageProcessor.supervise(worker_config.worker_class)
  end
  
  def operation (payload)
    lambda do
      begin
        message_processor_supervisor.actor.process_message(payload)
      rescue Exception => e
        puts e.message
        puts e.backtrace
        "FAILED"
      end
    end
  end
  
  def callback (header)
    lambda do |result|
      result == "SUCCEEDED" ? header.ack : header.reject(:requeue => worker_config.requeue_on_failure)
    end
  end

end
