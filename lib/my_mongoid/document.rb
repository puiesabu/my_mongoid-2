require "my_mongoid/fields"

module MyMongoid
  module Document
    extend ActiveSupport::Concern

    include Fields



    included do
      MyMongoid.register_model(self)
    end


    def initialize(attrs = nil)
      raise ArgumentError, 'The argument is not a Hash object' unless attrs.class == Hash 
      @attributes = {}
      @new_record = true
      process_attributes(attrs)
    end

 
   
    def attributes 
      @attributes
    end

    def read_attribute(name)
      @attributes[name]
    end

    def write_attribute(name, value)
      @attributes[name] = value
    end

    def new_record?
      @new_record
    end



    def process_attributes(attrs = nil)
      attrs ||= {}
      if !attrs.empty?
        attrs.each do |key, value|
          raise MyMongoid::UnknownAttributeError unless  self.class.fields.include? key.to_s

          self.send "#{key}=", value
        end
      end
    end
    alias_method  :attributes= ,  :process_attributes

    def to_document
      @attributes
    end

    def save
      @attributes["id"] = BSON::ObjectId.new unless  @attributes["_id"]
      self.class.collection.insert(to_document)
      @new_record = false
      true
    end


    
    

    module ClassMethods

      def is_mongoid_model?
        true
      end

      def collection_name
        self.to_s.tableize
      end

      def collection
        MyMongoid.session[collection_name]
      end

      def create(attrs = nil)
        record = self.new(attrs)
        record.save
        record
      end

      def find(attrs)
        records = {}
        if attrs.is_a? String
          records = collection.find("_id" => attrs)
        else 
          records = collection.find(attrs)
        end
        #raise RecordNotFoundError unless records.count > 0
        records
      end

      def instantiate(attrs) 
        record = self.new attrs
        record.instance_eval {
          @attributes = attrs
          @new_record = false
        }
        record
      end

    end
    
  end
end