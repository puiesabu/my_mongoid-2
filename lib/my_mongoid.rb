require "my_mongoid/version"
require 'active_support/all'

module MyMongoid
  module Document

    extend ActiveSupport::Concern

    included do
      MyMongoid.register_model(self)
    end


    def initialize(attrs = {})
      raise ArgumentError, 'The argument  is not a Hash object' unless attrs.class == Hash 
      
      @attributes = attrs
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



    module ClassMethods
      def is_mongoid_model?
        true
      end
    end
    
  end


  def self.models
    @models ||= []
  end

  



  def self.register_model(klass)
    models << klass
  end
end
