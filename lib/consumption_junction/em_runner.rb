class ConsumptionJunction::EmRunner
  include Celluloid
  
  WORKER_COUNT = 5
  MESSAGE_COUNT = 100
  QUEUE_NAME = 'foo.bar.baz'
  
  attr_accessor :amqp_connection, :em_thread, :server_config

  def initialize (server_config)
    @server_config = server_config
  end
  
  def start
    EventMachine.run do
      setup_connection
      create_subscriptions
    end
  end
  
  def setup_connection
    self.amqp_connection = AMQP.connect(:host => '127.0.0.1')
  end
  
  def create_subscriptions
    worker_configs.each do |worker_config|
      puts "Setting up subcriptions for #{worker_config}"
      worker_config.worker_count.times do
        
        message_processor_supervisor = ConsumptionJunction::MessageProcessor.supervise(worker_config.worker_class.to_s.classify.constantize)
        
        queue_channel = AMQP::Channel.new(amqp_connection)
        queue = queue_channel.queue(worker_config.queue, :durable => true)

        queue.subscribe(:ack => worker_config.ack) do |header, payload|

          operation = lambda do
            begin
              message_processor_supervisor.actor.process_message(payload)
            rescue Exception => e
              header.reject :requeue => true
            end
          end

          callback = lambda do |result|
            header.ack
          end

          EventMachine.defer(operation, callback)
        end
      end
    end
    
    puts "END: #create_subscriptions"
  end
  
  def worker_configs
    server_config.worker_configs
  end
end


# puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."
# 
# 
# (1..WORKER_COUNT).each do |i|
#   queue_channel = AMQP::Channel.new(connection)
#   queue = queue_channel.queue(QUEUE_NAME, :auto_delete => true)
# 
#   queue.subscribe(:ack => true) do |header, payload|
# 
#     operation = lambda do
#       sleep_time = rand(10) > 5 ? 5 : 0
#       sleep sleep_time
#       puts "Listener #{i} received a message: #{payload}, and slept for #{sleep_time}"
#       counter.increment
#     end
# 
#     callback = lambda do |result|
#       puts "Acking for listener #{i}"
#       header.ack
#       if counter.count == MESSAGE_COUNT
#         EventMachine.stop { exit }
#       end
#     end
# 
#     EventMachine.defer(operation, callback)
#   end
# end
# 
# channel = AMQP::Channel.new(connection)
# exchange = channel.direct("")
# (1..MESSAGE_COUNT).each do |i|
#   exchange.publish "Message #{i}", :routing_key => QUEUE_NAME
# end
