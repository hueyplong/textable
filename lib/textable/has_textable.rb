module Textable
  module Model

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def has_textable(name, options = {})
        send :include, InstanceMethods

        unless self.respond_to? :textables
          self.class_attribute :textables
          self.textables = {}
        end
        self.textables[name] = options
        
        has_one "#{name}".to_sym, :class_name => 'TextableEntry',
          :as => :item, :conditions => "textable_entry.item_fieldname = '#{name}'"

        after_save :save_textables

        define_method "#{name}=" do |data|
          if options[:as] == 'Hash'
            # Start with the hash as defined in has_textable
            textable_hash = order_textable_hash(options[:default])
            # Next let's load what's there already, if anything:
            text_content = textable_for(name).text_content
            if text_content.present?
              # There are existing values in the database, so we need to deal with them first
              existing_values = Marshal.load(Base64.decode64(text_content))
              # Merge the existing values into our hash
              textable_hash.merge!(existing_values)
            end
            # If there is data coming in to be set, merge it in
            textable_hash.merge!(data.symbolize_keys) if data.present?
            # Loop through and reset 'true' and 'false' strings to the proper classes
            textable_hash.each { |k, v|
              textable_hash[k] = true  if v == 'true'
              textable_hash[k] = false if v == 'false'
            }
            # Encode the Ordered Hash
            encoded_hash = Base64.encode64(Marshal.dump(textable_hash))
            store_textable_for(name, encoded_hash)
          else
            # Plain ol text data
            store_textable_for(name, data)
          end
        end
        
        define_method name do
          if options[:as] == 'Hash'
            # Start with the hash as defined in has_textable
            textable_hash = order_textable_hash(options[:default])
            # Next let's load what's there already, if anything:
            text_content = textable_for(name).text_content
            if text_content.present?
              # There are existing values in the database, so we need to deal with them first
              existing_values = Marshal.load(Base64.decode64(text_content)).symbolize_keys
              # Merge the existing values into our hash
              textable_hash.merge!(existing_values)
            else
              order_textable_hash(options[:default])
            end
          else
            textable_for(name).text_content
          end
        end
        
      end

    end


    module InstanceMethods

      def textable_for(name)
        @_textables ||= {}
        @_textables[name] ||= TextableEntry.find_or_create_for(name, self, self.class.textables[name])
      end
      
      def store_textable_for(name, data)
        textable_for(name).text_content = data
      end

      def each_textable
        self.class.textables.each do |name, textable|
          yield(name, textable_for(name))
        end
      end

      def save_textables
        logger.info("[Textable] Saving Textables...")
        each_textable do |name, textable|
          textable.send(:save)
        end
      end
      
      def order_textable_hash(obj)
        if RUBY_VERSION >= '1.9'
          return obj
        else
          returning(ActiveSupport::OrderedHash.new) do |map|
            obj.each {|k,v| map[k] = v }
          end
        end
      end

    end

  end
end

ActiveRecord::Base.send :include, Textable::Model
