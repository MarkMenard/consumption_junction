require 'spec_helper'

module ConsumptionJunction
  describe EmWorkerSubscription do
    let(:amqp_connection) { mock }
    let(:worker_config) { mock }
    
    describe "#create_subscription" do
      it "creates an instance with an active subscription" do
        subscription_instance = mock()
        subscription_instance.should_receive(:create_subscription)
        EmWorkerSubscription.should_receive(:new).with(amqp_connection, worker_config).and_return(subscription_instance)
        EmWorkerSubscription.create_subscription(amqp_connection, worker_config).should == subscription_instance
      end
    end
    
    describe "executing the operation" do
      it "sets the job_state to ACTIVE" do
        actor = mock
        actor.stub!(:process_message)
        
        subscription = EmWorkerSubscription.new(amqp_connection, worker_config)
        subscription.stub!(:message_processor_actor).and_return(actor)
        subscription.operation("").call
        subscription.job_state.should == EmWorkerSubscription::BUSY
      end
    end
  end
end
