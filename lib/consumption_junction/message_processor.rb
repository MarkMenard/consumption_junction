class ConsumptionJunction::MessageProcessor
  include Celluloid
  
  attr_accessor :message_count, :worker_class
  
  def initialize (worker_class)
    log "[ ConsumptionJunction::MessageProcessor ] CREATE MessageProcessor for #{worker_class}"
    self.worker_class = worker_class
    self.message_count = 0
    log "[ ConsumptionJunction::MessageProcessor ] END initialize()"
  end
  
  def process_message (message)
    log "-+" * 25
    log "[ ConsumptionJunction::MessageProcessor ] BEGIN MessageProcessor#process_message #{message}"
    self.message_count = message_count + 1
    log "[ ConsumptionJunction::MessageProcessor ] INFO MessageProcessor #{self} count = #{message_count}"
    build_worker.process_message(message)
    log "[ ConsumptionJunction::MessageProcessor ] END MessageProcessor#process_message #{message}"
    log "-+" * 25
  end
  
  def build_worker
    worker_class.new
  end
  
  def log (message)
    if defined? ::Rails
      ::Rails.logger.debug message
    else
      puts message
    end
  end
end