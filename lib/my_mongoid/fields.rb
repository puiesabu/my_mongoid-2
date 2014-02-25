require "my_mongoid/document"

module MyMongoid

  class Field
    attr_accessor :name, :options

    def initialize(name, options)
      @name = name
      @options = options
    end
  end


  module Document 
    module Fields
      extend ActiveSupport::Concern

      included do
        class_attribute :fields
        self.fields = {}
        field :_id , :as => :id
      end


      module ClassMethods

      
        def field(key, options = nil)

          key = key.to_s


          raise DuplicateFieldError if self.fields.has_key?(key)

          self.fields[key] = Field.new(key, options)

          define_method(key){
            @attributes["#{key}"]
          }
          define_method("#{key}="){ |value|
            if @attributes["#{key}"] != value
              changed_attributes["#{key}"] = @attributes["#{key}"]
              @attributes["#{key}"] = value
              
            end
          }

          if options 
            options.each do |k, v| 

              if k == :as 
                v = v.to_s
                self.fields[v] = Field.new(v, nil)

                define_method(v){
                  @attributes["#{key}"]
                }
                define_method("#{v}="){ |value|
                  if @attributes["#{key}"] != value
                    changed_attributes["#{key}"] = @attributes["#{key}"]
                    @attributes["#{key}"] = value
                  end
                }
              end
            end
          end

        end

        def fields
          Document.fields
        end


      end

    end

  end


end