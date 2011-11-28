class ConsumptionJunction::EmWorkerSubscription
  
  IDLE = 'IDLE'
  BUSY = 'BUSY'
  ACTIVE = 'ACTIVE'
  CANCELLED = 'CANCELLED'
  
  attr_reader :amqp_connection, :worker_config
  
  def self.create_subscription (amqp_connection, worker_config)
    subscription = ConsumptionJunction::EmWorkerSubscription.new(amqp_connection, worker_config)
    subscription.create_subscription
    subscription
  end
  
  def initialize (amqp_connection, worker_config)
    @amqp_connection = amqp_connection
    @worker_config = worker_config
    @job_state_mutex = Mutex.new
    @job_state = IDLE
    @subscription_state_mutex = Mutex.new
  end
  
  def create_subscription
    @subscription_state_mutex.synchronize do 
      queue.subscribe(:ack => worker_config.ack, &method(:handle_message))
      @subscription_state = ACTIVE 
    end
  end
  
  def cancel
    @subscription_state_mutex.synchronize do
      queue.unsubscribe
      @subscription_state = CANCELLED
    end
  end
  
  def handle_message (header, payload)
    EventMachine.defer(operation(payload), callback(header))
  end
  
  def operation (payload)
    lambda do
      result = ''
      @job_state_mutex.synchronize { @job_state = BUSY }
      begin
        result = message_processor_actor.process_message(payload)
      rescue StandardError => e
        puts e.message
        puts e.backtrace
        result = "FAILED"
      end
      result
    end
  end
  
  def callback (header)
    lambda do |result|
      result == "SUCCEEDED" ? header.ack : header.reject(:requeue => worker_config.requeue_on_failure)
      @job_state_mutex.synchronize { @job_state = IDLE }
    end
  end
  
  
  def message_processor_supervisor
    @message_processor_supervisor ||= ConsumptionJunction::MessageProcessor.supervise(worker_config.worker_class)
  end
  
  def message_processor_actor
    message_processor_supervisor.actor
  end
  
  def job_state
    @job_state_mutex.synchronize { @job_state }
  end
  
  def subscription_state
    @subscription_state_mutex.synchronize { @subscription_state }
  end
  
  def channel
    @channel ||= AMQP::Channel.new(amqp_connection)
    @channel.prefetch(1)
    @channel
  end
  
  def queue
    @queue ||= channel.queue(worker_config.queue, :durable => true)
  end

end
