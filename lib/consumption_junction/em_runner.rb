module ConsumptionJunction
  class EmRunner
    include Celluloid

    attr_accessor :server_config

    def initialize (server_config)
      @server_config = server_config
      @subscriptions = []
    end

    def start
      EventMachine.run do
        create_subscriptions
      end
    end

    def amqp_connection
      @amqp_connection ||= AMQP.connect(:host => '127.0.0.1')
    end
    
    def channel
      return @channel if @channel
      @channel = AMQP::Channel.new(amqp_connection)
      @channel
    end

    def create_subscriptions
      worker_configs.each do |worker_config|
        puts "Setting up subcriptions for #{worker_config}"
        worker_config.worker_count.times do
          EmWorkerSubscription.create_subscription(channel, worker_config)
        end
      end

      puts "END: #create_subscriptions"
    end

    private

    def worker_configs
      server_config.worker_configs
    end
  end
end
