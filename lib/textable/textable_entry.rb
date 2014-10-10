class TextableEntry < ActiveRecord::Base
  belongs_to  :item, :polymorphic => true

  attr_accessible :item_id, :item_type, :item_fieldname

  # Find or create the textable row
  def self.find_or_create_for(name, obj, options)
    self.find_or_create_by_item_id_and_item_type_and_item_fieldname(obj.id, obj.class.table_name.classify, name.to_s)
  end
  
  
end