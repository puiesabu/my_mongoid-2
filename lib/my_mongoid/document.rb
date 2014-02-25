require "my_mongoid/fields"

module MyMongoid
  module Document
    extend ActiveSupport::Concern

    include Fields



    included do
      MyMongoid.register_model(self)
    end


    def initialize(attrs = nil)
      raise ArgumentError, 'The argument  is not a Hash object' unless attrs.class == Hash 
      @attributes = {}
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
      true
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



    end
    
  end
end