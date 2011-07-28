require 'rubygems'
require 'carrot'
require 'celluloid'

MESSAGE_COUNT = 20_000
QUEUE_NAME = "example.queue.2"

@queue = Carrot.queue(QUEUE_NAME, :durable => true)

i = 0

while true
  i= i + 1
  puts "Publishing message #{i} on #{QUEUE_NAME}"
  @queue.publish "Message #{i} for #{QUEUE_NAME}"
  sleep 0.01
end
