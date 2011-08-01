class ConsumptionJunction::MessageProcessor
  include Celluloid
  
  attr_accessor :message_count, :worker_class
  
  def initialize (worker_class)
    log "CREATE MessageProcessor for #{worker_class}"
    self.worker_class = worker_class
    self.message_count = 0
  end
  
  def process_message (message)
    log "-+" * 25
    log "BEGIN MessageProcessor#process_message #{message}"
    self.message_count = message_count + 1
    log "INFO MessageProcessor #{self} count = #{message_count}"
    build_worker.process_message(message)
    log "END MessageProcessor#process_message #{message}"
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