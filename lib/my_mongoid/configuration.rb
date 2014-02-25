
module MyMongoid

  class Configuration
    include Singleton

    attr_accessor :database, :host    
  
  end
end

