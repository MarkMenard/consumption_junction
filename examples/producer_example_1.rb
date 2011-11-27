require 'rubygems'
require 'carrot'

MESSAGE_COUNT = 20_000
QUEUE_NAME = "example.queue.1"

@queue = Carrot.queue(QUEUE_NAME, :durable => true)

i = 0
counter = lambda do
  i = i + 1
  i
end

while true
  2000.times do
    count = counter.call
    puts "Publishing message #{count} on #{QUEUE_NAME}"
    @queue.publish "Message #{count} for #{QUEUE_NAME}"
  end
  sleep 1
end
