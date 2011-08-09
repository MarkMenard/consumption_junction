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
    log "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
    log "[ ConsumptionJunction::MessageProcessor ] BEGIN MessageProcessor#process_message using #{worker_class.to_s} #{message}"
    self.message_count = message_count + 1
    log "[ ConsumptionJunction::MessageProcessor ] INFO #{to_s}"
    result = build_worker.process_message(message)
    log "[ ConsumptionJunction::MessageProcessor ] END MessageProcessor#process_message result = #{result} for message = #{message}"
    log "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
    result
  end
  
  def build_worker
    worker_class.new
  end
  
  def log (message)
    if defined? ::Rails
      ::Rails.logger.info message
    else
      log message
    end
  end
  
  def to_s
    "#{self.class.to_s}< worker_class => #{worker_class.to_s}, message_count => #{message_count} >"
  end
end