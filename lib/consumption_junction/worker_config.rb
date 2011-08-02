module ConsumptionJunction
  class WorkerConfig
    attr_accessor :worker_class, :options
    
    def initialize (worker_class, options)
      @worker_class = worker_class
      @options = options
    end
    
    def queue
      options[:queue]
    end
    
    def ack
      !!options[:use_basic_ack]
    end
    
    def requeue_on_failure
      !!options[:requeue_on_failure]
    end
    
    def worker
      worker_class.new
    end
    
    def worker_count
      options[:count]
    end
        
  end
end
