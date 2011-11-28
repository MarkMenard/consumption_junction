module ConsumptionJunction
  class EmRunner
    include Celluloid

    attr_accessor :server_config, :subscriptions

    def initialize (server_config)
      @server_config = server_config
      @subscriptions = []
      trap("SIGINT") { stop }
    end

    def start
      EventMachine.run do
        create_subscriptions
      end
    end
    
    def stop
      puts "Caught SIGNINT"
      puts "Shutting down subscriptions"
      puts "busy_worker_count = #{busy_worker_count}"
      EventMachine.next_tick(&method(:cancel_subscriptions))
    end
    
    def cancel_subscriptions
      @subscriptions.each do |subscription|
        subscription.cancel
      end
      EventMachine.add_periodic_timer(0.1, &method(:stop_event_loop))
    end
    
    def stop_event_loop
      busy_worker_count = self.busy_worker_count
      if busy_worker_count == 0
        puts "All jobs finished shutting down EventMachine event loop."
        EventMachine.stop_event_loop
      else
        puts "There are still #{busy_worker_count} jobs processing."
      end
    end
    
    def busy_worker_count
      @subscriptions.find_all { |subscription| subscription.job_state == EmWorkerSubscription::BUSY }.size
    end
    
    def create_subscriptions
      worker_configs.each do |worker_config|
        puts "Setting up subcriptions for #{worker_config}"
        worker_config.worker_count.times do
          @subscriptions << EmWorkerSubscription.create_subscription(amqp_connection, worker_config)
        end
      end

      puts "END: #create_subscriptions"
    end

    def amqp_connection
      @amqp_connection ||= AMQP.connect(:host => server_config.server_host)
    end
    
    private

    def worker_configs
      server_config.worker_configs
    end
  end
end
