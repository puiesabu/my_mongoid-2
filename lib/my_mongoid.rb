require "my_mongoid/version"
require "my_mongoid/document"
require "my_mongoid/field"


module MyMongoid


  def self.models
    @models ||= []
  end

  def self.register_model(klass)
    models << klass
  end

  class DuplicateFieldError < StandardError
  
  end

  class UnknownAttributeError < StandardError

  end
end
