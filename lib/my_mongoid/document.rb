require 'active_support/all'
require "my_mongoid/field"

module MyMongoid
  module Document

    extend ActiveSupport::Concern




    included do
      class_attribute :fields
      self.fields = {}
      field :_id
      MyMongoid.register_model(self)
    end


    def initialize(attrs = {})
      raise ArgumentError, 'The argument  is not a Hash object' unless attrs.class == Hash 
      
      @attributes = {}

      process_attributes(attrs)

      #return unless self.fields.empty?
      # @attributes.each_key {|key|
      #   Document.fields[key] = MyMongoid::Field.new
      # }


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

      def field(key)

        key = key.to_s

        raise DuplicateFieldError if self.fields.has_key?(key)

        self.fields[key] = Field.new(key)

        define_method(key){
          @attributes["#{key}"]
        }
        define_method("#{key}="){ |value|
          @attributes["#{key}"] = value
        }


      end

      def fields
        Document.fields
      end


    end
    
  end
end