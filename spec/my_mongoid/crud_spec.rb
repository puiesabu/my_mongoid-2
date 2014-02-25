
require "spec_helper"


describe "Should be able to configure MyMongoid:" do 



  # it "should connect to mongodb" do 
  #   config = MyMongoid::Config 
  #   expect(config.database).to  eq("my_mongoid")
  #   expect(config.host).to eq("localhost:27017")
  # end

  # it "should get session after connect to mongodb" do 
  #   expect(MyMongoid.session).to be_an(Moped::Session)
  # end

  describe "  MyMongoid::Configuration" do 
    it "should be a singleton class"  do 
      expect(MyMongoid::Configuration.instance).to be_an(MyMongoid::Configuration)
      #expect(MyMongoid::Configuration.new).to raise_error(NoMethodError)
    end
    it "should have #host accessor" do 
      MyMongoid::Configuration.instance.host = "localhost:27017"
      expect(MyMongoid::Configuration.instance.host).to eq("localhost:27017")
    end
    it "should have #database accessor" do 
      MyMongoid::Configuration.instance.database = "my_mongoid"
      expect(MyMongoid::Configuration.instance.database).to eq("my_mongoid")
    end
  end

  describe "MyMongoid.configuration" do 
    it "should return the MyMongoid::Configuration singleton" do 
      expect(MyMongoid.configuration).to be_an(MyMongoid::Configuration)
    end
  end

  describe "MyMongoid.configure" do 
    it "should yield MyMongoid.configuration to a block" do 
      MyMongoid.configure do |config|
        config.database = "my_mongoid"
        config.host = "localhost:27017"
      end
      expect(MyMongoid::Configuration.instance.host).to eq("localhost:27017")
      expect(MyMongoid::Configuration.instance.database).to eq("my_mongoid")
    end
  end

end


describe "Should be able to get database session:" do   
  describe "MyMongoid.session" do 
    it "should return a Moped::Session" do 
      expect(MyMongoid.session).to be_an(Moped::Session)
    end
    it "should memoize the session @session" do 
      expect(MyMongoid.instance_variable_get(:@session)).to be_an(Moped::Session)
    end
    it "should raise MyMongoid::UnconfiguredDatabaseError if host and database are not configured" do 
      MyMongoid.configure do |config|
        config.database = nil
        config.host = nil
      end
      expect {
        MyMongoid.session
      }.to raise_error(MyMongoid::UnconfiguredDatabaseError)
    end
  end
end

class Event
  include MyMongoid::Document
  field :public
  field :created_at
end



describe  "Should be able to create a record:" do 

  context "model collection:" do 
    it "Model.collection_name should use active support's titleize method" do 
      expect(Event.collection_name).to eq("events")
    end

    it " Model.collection should return a model's collection" do 
      MyMongoid.configure do |config|
        config.database = "my_mongoid"
        config.host = "localhost:27017"
      end
      expect(Event.collection).to be_an(Moped::Collection)
    end
  end

  context "Should be able to create a record" do
     let(:attributes) {
       {"id" => "123", "public" => true}
     }

    let(:event) {
      Event.new(attributes)
    }

    it "#to_document" do 
      expect(event.to_document).to be_an(BSON::Document)
    end 

    describe "Should be able to create a record:" do 
      it "#should return a saved record " do
        expect(Event.create(attributes)).to be_an(MyMongoid::Document)
      end
    end

    describe "#save" do 
      before do
        MyMongoid.configure do |config|
          config.database = "my_mongoid"
          config.host = "localhost:27017"
        end
      end


      it "should insert a new record into the db" do 

      end
      it "should return true" do 
        expect(event.save).to be(true)
      end
      it "should make Model#new_record return false" do 
        event.save
        expect(event.new_record?).to be(false)
      end
    end

  end
 

end
