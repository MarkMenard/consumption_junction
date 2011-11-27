module ConsumptionJunction
  class WorkerConfig
    attr_accessor :worker_class_name, :options
    
    def initialize (worker_class_name, options)
      @worker_class_name = worker_class_name
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
    
    def worker_class
      worker_class_name.to_s.classify.constantize
    end
    
    def worker
      worker_class_name.new
    end
    
    def worker_count
      options[:count]
    end
        
  end
end
