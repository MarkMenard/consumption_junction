require 'spec_helper'

describe ConsumptionJunction::MessageProcessor do
  describe "process_message" do
    it "calls execute on an instance of the worker" do
      worker_instance = mock
      worker_instance.should_receive(:process_message)

      worker_class = mock
      worker_class.should_receive(:new).with("").and_return(worker_instance)
      message_processor = ConsumptionJunction::MessageProcessor.new(worker_class)
      message_processor.process_message("")
      
    end
  end
end