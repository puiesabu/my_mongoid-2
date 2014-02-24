require 'active_support/all'
require "moped"


require "my_mongoid/version"
require "my_mongoid/document"
require "my_mongoid/fields"
require "my_mongoid/configuration"



module MyMongoid

  @@session = nil

  def self.configure(&block)
    block_given? ? yield(Configuration.instance) : Configuration.instance
  end

  def self.configuration  
    Configuration.instance
  end

  def self.session
    @@session = Moped::Session.new([ Configuration.instance.host ])
    @@session.use Configuration.instance.database
    @@session
  end



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
