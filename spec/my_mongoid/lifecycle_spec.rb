require "spec_helper"



class TestModel
  include MyMongoid::Document
  field :public
  field :created_at

  attr_reader :around_save_called , :create_save_called 

  around_save do 
    puts "hello"
    @around_save_called = true
  end

  

  around_create do 
    @around_create_called = true
  end



end


def clean_db
  TestModel.collection.drop
end


describe "all hooks: " do
  before do 
    MyMongoid.configure do |config|
      config.host = "127.0.0.1:27017"
      config.database = "my_mongoid_test"
    end
  end

  let(:klass) do
    TestModel
  end
  

  describe "run create callbacks" do 
   

    it "should run callbacks when saving a new record" do
      model = TestModel.create({public: 1, created_at: Time.now})
      p model
      expect(model.around_save_called).to eq(true)
    end

    it " should run callbacks when creating a new record" do
      model = TestModel.new({public: 1, created_at: Time.now})
      model.save
      expect(model.around_save_called).to eq(true)
    end

  end


  describe "run save callbacks" do 

    it " should run callbacks when saving a new record" do
      model = TestModel.create({public: 1, created_at: Time.now})
      expect(model.around_create_called).to eq(true)
    end

    it " should run callbacks when saving a persisted record" do

    end
  
  end


  describe "Should define lifecycle callbacks" do
    
    it "includes the before_destroy callback" do
      expect(klass).to respond_to(:before_delete)
    end

    it "includes the after_destroy callback" do
      expect(klass).to respond_to(:after_delete)
    end

    it "includes the before_save callback" do
      expect(klass).to respond_to(:before_save)
    end

    it "includes the after_save callback" do
      expect(klass).to respond_to(:after_save)
    end

    it "includes the before_update callback" do
      expect(klass).to respond_to(:before_update)
    end

    it "includes the after_update callback" do
      expect(klass).to respond_to(:after_update)
    end

    it "includes the before_validation callback" do
      expect(klass).to respond_to(:before_create)
    end

    it "includes the after_validation callback" do
      expect(klass).to respond_to(:after_create)
    end

    it "includes the after_initialize callback" do
      expect(klass).to respond_to(:after_initialize)
    end

    it "includes the after_build callback" do
      expect(klass).to respond_to(:after_find)
    end

    it "not includes the before_initialize callback" do
      expect(klass).not_to respond_to(:before_initialize)
    end

    it "not includes the before_build callback" do
      expect(klass).not_to respond_to(:before_find)
    end


    it "not includes the around_initialize callback" do
      expect(klass).not_to respond_to(:around_initialize)
    end

    it "not includes the around_build callback" do
      expect(klass).not_to respond_to(:around_find)
    end


  end





  


  # describe "should declare callback hooks" do
  #   let(:klass) {
  #     Class.new(ATM)
  #   }

  #   let(:atm) {
  #     klass.new(account)
  #   }

  #   it "should be able to register a :command callback" do
  #     expect {
  #       klass.module_eval do
  #         set_callback :command, :foo
  #       end
  #     }.to_not raise_error
  #   end
  # end

  # describe "should run callbacks when #deposit or #withdraw is invoked" do
  #   it "should run the :command callbacks when #deposit is invoked" do
  #     expect(atm).to receive(:run_callbacks).with(:command)
  #     atm.deposit(100)
  #   end

  #   it "should run the :command callbacks when #withdraw is invoked" do
  #     expect(atm).to receive(:run_callbacks).with(:command)
  #     atm.withdraw(100)
  #   end
  # end

  # describe "logging concern" do
  #   it "should log around #deposit" do
  #     expect(atm).to receive(:log).ordered
  #     expect(account).to receive(:deposit).ordered
  #     expect(atm).to receive(:log).ordered
  #     atm.deposit(100)
  #   end
  # end

  # describe "text notification concern" do
  #   it "should invoke #send_sms after #deposit" do
  #     expect(account).to receive(:deposit).with(100).ordered
  #     expect(atm).to receive(:send_sms).ordered
  #     atm.deposit(100)
  #   end
  # end

  # describe "authentication concern" do
  #   after {
  #     atm.deposit(100)
  #   }

  #   context "account.valid_access? returns true" do
  #     it "should call Account#deposit" do
  #       expect(account).to receive(:deposit).with(100)
  #     end
  #   end

  #   context "account.valid_access? returns false" do
  #     before {
  #       allow(account).to receive(:valid_access?) { false }
  #     }

  #     it "should cancel #deposit" do
  #       expect(account).to_not receive(:deposit)
  #     end

  #     it "should cancel after callbacks" do
  #       expect(account).to_not receive(:send_sms)
  #     end
  #   end
  # end
end
