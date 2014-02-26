require "spec_helper"

describe MyMongoid::Document do


  let(:attributes) {
   {"_id" => "123", "public" => true}
  }

  let(:event) {
    Event.new(attributes)
  }

  it "is a module" do
    expect(MyMongoid::Document).to be_a(Module)
  end

  describe ".new" do
   

    it "can instantiate a model with attributes" do
      expect(event).to be_an(Event)
    end

    it "throws an error if attributes it not a Hash" do
      expect {
        Event.new(100)
      }.to raise_error(ArgumentError)
    end
  end


  describe "#read_attribute" do 
    it "can read the attributes of model" do
      expect(event.attributes).to eq(attributes)
    end
  end

  describe "#write_attribute" do 
    it "can set an attribute with #write_attribute" do
      event.write_attribute("id","234")
      expect(event.read_attribute("id")).to eq("234")
    end
  end

  describe "#process_attributes"


  describe "#new_record?"

end