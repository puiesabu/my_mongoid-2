require 'active_support/all'
require "moped"


require "my_mongoid/version"
require "my_mongoid/document"
require "my_mongoid/fields"
require "my_mongoid/configuration"



module MyMongoid

  extend self
  @session = nil

  def configure(&block)
    block_given? ? yield(Configuration.instance) : Configuration.instance
  end

  def configuration  
    Configuration.instance
  end

  def session
    if Configuration.instance.host.nil? or Configuration.instance.database.nil?
      raise UnconfiguredDatabaseError
    end
    @session = Moped::Session.new([ Configuration.instance.host ])
    @session.use Configuration.instance.database
    @session
  end



  def models
    @models ||= []
  end

  def register_model(klass)
    models << klass
  end

  class DuplicateFieldError < StandardError
  
  end

  class UnknownAttributeError < StandardError

  end

  class UnconfiguredDatabaseError < StandardError 
  end

  class RecordNotFoundError  < StandardError 
  end

end



