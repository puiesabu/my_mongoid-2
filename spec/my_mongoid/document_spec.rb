require "spec_helper"

describe MyMongoid::Document do
  it "is a module" do
    expect(MyMongoid::Document).to be_a(Module)
  end
  describe ".new"
  describe "#read_attribute"
  describe "#write_attribute"
  describe "#process_attributes"
  describe "#new_record?"
end