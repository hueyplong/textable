class TextableEntry < ActiveRecord::Base
  belongs_to  :item, :polymorphic => true

  # using after_save instead of touch => true on the belongs_to because we want to do something custom on the touch
  after_save :touch_parent

  # Find or create the textable row
  def self.find_or_create_for(name, obj, options)
    self.find_or_create_by_item_id_and_item_type_and_item_fieldname(obj.id, obj.class.to_s, name.to_s)
  end
  
  private
  def touch_parent
    return unless self.item.present?
    # using update_all to bypass the callbacks on the item class, since they could trigger a save, which would trigger an infinite loop
    self.item.class.update_all({:updated_at => Time.now}, ['id = ?', self.item.id])
  end
  
end