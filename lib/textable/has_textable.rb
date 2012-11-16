module Textable
  module Model

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def has_textable(name, options = {})
        send :include, InstanceMethods

        write_inheritable_attribute(:textables, {}) if textables.nil?
        textables[name] = options
        
        has_one "#{name}".to_sym, :class_name => 'TextableEntry',
          :as => :item, :conditions => "textable_entry.item_fieldname = '#{name}'"

        after_save :save_textables

        define_method "#{name}=" do |data|
          store_textable_for(name, data)
        end
        
        define_method name do
          textable_for(name).text_content
        end
        
      end

      def textables
        read_inheritable_attribute(:textables)
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
        logger.info("[Textable]] Saving Textables...")
        each_textable do |name, textable|
          textable.send(:save)
        end
      end

    end

  end
end

ActiveRecord::Base.send :include, Textable::Model
