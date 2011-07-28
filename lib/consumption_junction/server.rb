module ConsumptionJunction
  class Server

    class << self
      attr_accessor :server_host, :server_port, :workers

      def amqp_server_host (server_host)
        self.server_host = server_host
      end

      def amqp_server_port (server_port)
        self.server_port = server_port
      end

      def worker (class_name, options = {})
        worker_configs << WorkerConfig.new(class_name, options)
      end

      def worker_configs
        @worker_configs ||= []
      end
    end
  end
end
