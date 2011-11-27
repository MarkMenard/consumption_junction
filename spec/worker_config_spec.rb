require 'spec_helper'

class TestWorker
end



describe ConsumptionJunction::WorkerConfig do
  
  let(:config) { ConsumptionJunction::WorkerConfig.new(:test_worker, :queue => 'test.queue') }
  
  describe "#worker_class" do
    it "returns the class of the worker" do
      config.worker_class.should == TestWorker
    end
  end
end