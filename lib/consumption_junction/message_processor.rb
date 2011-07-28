class ConsumptionJunction::MessageProcessor
  include Celluloid
  
  attr_accessor :message_count, :worker_class
  
  def initialize (worker_class)
    puts "Create MessageProcessor for #{worker_class}"
    self.worker_class = worker_class
    self.message_count = 0
  end
  
  def process_message (message)
    puts "MessageProcessor#process_message #{message}"
    self.message_count = message_count + 1
    puts "MessageProcessor #{self} count = #{message_count}"
    build_worker.process_message(message)
  end
  
  def build_worker
    worker_class.new
  end
end