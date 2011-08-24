$:.push File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'consumption_junction'

EventMachine.threadpool_size = 200

require 'amqp'

class MyWorker
  def initialize (message)
    @message = message
  end
  
  def process_message
    puts "MyWorker#call #{@message}"
  end
end

class OtherWorker
  def initialize (message)
    @message = message
  end
  
  def process_message
    puts "OtherWorker: #{@message}"
  end
end

class MyServer < ConsumptionJunction::Server
  amqp_server_host 'localhost'
  amqp_server_port '5672'
  worker :my_worker, :queue => 'example.queue.1', :use_basic_ack => true, :count => 50
  worker :other_worker, :queue => 'example.queue.2', :use_basic_ack => true, :count => 50
end


em_runner_2 = ConsumptionJunction::EmRunner.new(MyServer)
em_runner_2.start

