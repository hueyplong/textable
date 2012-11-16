class CreateTextableEntries < ActiveRecord::Migration
  def self.up
    create_table :textable_entries do |t|
      t.string      :item_type,      :limit => 75
      t.integer     :item_id
      t.string      :item_fieldname, :limit => 75
      t.timestamps
      t.text        :text_content
    end
    add_index :textable_entries, [ :item_type, :item_id ]
  end

  def self.down
    drop_table :textable_entries
  end
end
