require "my_mongoid/fields"
require "active_support"
require "active_model"

module MyMongoid
  module Document
    extend ActiveSupport::Concern
  



    include Fields
    included do
      MyMongoid.register_model(self)
      extend ActiveModel::Callbacks
      define_model_callbacks :create, :delete, :save, :update
      define_model_callbacks :find, :initialize, only: :after
    end



    def initialize(attrs = nil)
      raise ArgumentError, 'The argument is not a Hash object' unless attrs.class == Hash 
      @attributes = {}
      @new_record = true

      unless attributes.key?('id') or attributes.key?('_id')
        self._id = BSON::ObjectId.new
      end 
      process_attributes(attrs)
   
    end

 
   
    def attributes 
      @attributes
    end

    def read_attribute(name)
      @attributes[name]
    end

    def write_attribute(name, value)
      if @attributes[name] != value
        changed_attributes[name] = @attributes[name]
        @attributes[name] = value
      end
    end

    def to_document
       @attributes
    end

    def save 
      run_callbacks :save do

        if @new_record == true
          self.class.collection.insert(@attributes)
        else changed?
          update_document
        end
        #self.class.collection.insert(@attributes)
        @new_record = false
        true
      end
      true
    end


    def save(create = nil)
      run_callbacks :save do
        if create    
          run_callbacks :create do

            if @new_record == true
              self.class.collection.insert(@attributes)
            else changed?
              update_document
            end
            #self.class.collection.insert(@attributes)
            @new_record = false
            return true
          end
        else     
            if @new_record == true
              self.class.collection.insert(@attributes)
            else changed?
              update_document
            end
            #self.class.collection.insert(@attributes)
            @new_record = false
            return true
        end
        true
      end
    end

    def atomic_updates
      if !self.new_record? && self.changed?
        set = {}
        set["$set"] = {}
        self.changed_attributes.each_pair do |k, v|
          set["$set"][k] = self.read_attribute(k)
        end
        set
      else
        {}
      end
    end

    def update_document
      self.class.collection.find({"_id" => self._id}).update(self.atomic_updates) if changed?
      @changed_attributes = {}
    end


    def new_record?
      @new_record
    end

    def changed?
      changed_attributes != {}
    end

    def update_attributes(attrs = nil)
      process_attributes(attrs)
      update_document
    end

    def deleted?
      @deleted ||=false
    end
    def delete
      self.class.collection.find({"_id" => self._id}).remove
      @deleted = true
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
    def changed_attributes
      @changed_attributes ||= {}
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
        MyMongoid.session[collection_name.to_sym]
      end

      def instantiate(attrs = nil)
        attributes = attrs || {}
        doc = allocate
        doc.instance_variable_set(:@attributes, attributes)  
        doc.instance_variable_set(:@new_record , false)
        doc 
      end

      def create(attrs = nil)

          attributes = attrs || {}
          doc = allocate
          doc.instance_variable_set(:@attributes, attributes)
          doc.instance_variable_set(:@new_record, true)
          doc.save(:create)
          doc

      end

      def find(condition)
        if condition.instance_of? String
          condition = { _id: condition }
        end
        result = self.collection.find(condition).one
        raise RecordNotFoundError unless result
        self.instantiate(result)
      end

    end
    
  end
end