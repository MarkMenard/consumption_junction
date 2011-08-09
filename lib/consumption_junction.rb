require 'celluloid'
require 'amqp'
require 'active_support/core_ext/string/inflections'

module ConsumptionJunction
end

require "#{File.dirname(__FILE__)}/consumption_junction/em_runner"
require "#{File.dirname(__FILE__)}/consumption_junction/message_processor"
require "#{File.dirname(__FILE__)}/consumption_junction/queue_listener"
require "#{File.dirname(__FILE__)}/consumption_junction/server"
require "#{File.dirname(__FILE__)}/consumption_junction/version"
require "#{File.dirname(__FILE__)}/consumption_junction/worker_config"

