class TextableEntry < ActiveRecord::Base
  belongs_to  :item, :polymorphic => true
  
  attr_accessible :item_id, :item_type, :item_fieldname

  validates :item_id, :item_type, :item_fieldname, :presence => true

  # Find or create the textable row
  def self.find_or_create_for(name, obj, options)
    self.find_or_create_by_item_id_and_item_type_and_item_fieldname(obj.id, self.smart_type_for(obj), name.to_s)
  end
  
  def failsafe(sender)
    self.item_id = sender.id if self.item_id.blank?
    self.item_type = self.class.smart_type_for(sender) if self.item_type.blank?
  end
  
  def self.smart_type_for(obj)
    obj.class.table_name.classify
  end
end