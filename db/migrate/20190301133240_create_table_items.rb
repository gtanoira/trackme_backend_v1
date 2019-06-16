class CreateTableItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.bigint   :company_id,   null: false
      t.bigint   :customer_id,  null: false
      t.string   :item_id,      null: false,  comment: 'This is the ID that goes in the sticker attached to the box'
      t.bigint   :internal_order_id, null: false, comment: 'Internal order ID where this item belongs to'
      t.integer  :item_type,    default: 0, comment: 'Determines the type of content of the Item (enum)'
      t.integer  :status,       null: false, default: 0, comment: 'Specifies the actual status of the item in the process of delivering (ENUM)'
      t.string   :deleted_by
      t.string   :deleted_cause

      t.string   :manufacter
      t.string   :model
      t.string   :part_number
      t.string   :serial_number
      t.integer  :condition,   null: false, default: 0, comment: 'Item type: new, used, etc. (enum)'    
      t.text     :contents, :limit => 4294967295

      t.integer  :unit_length, default: 0, comment: 'Unit of measure for distance (enum)'
      t.decimal  :width,   precision: 9, scale: 2
      t.decimal  :height,  precision: 9, scale: 2
      t.decimal  :length,  precision: 9, scale: 2

      t.integer  :unit_weight, default: 0, comment: 'Unit of measure for weight (enum)'
      t.decimal  :weight,  precision: 9, scale: 2

      t.integer  :unit_volume, default: 0, comment: 'Unit of measure for volume weight (enum)'
      t.decimal  :volume_weight,   precision: 9, scale: 2

    end

    # Add foreign keys
    add_foreign_key :items, :companies, column: :company_id
    add_foreign_key :items, :entities,  column: :customer_id
    add_foreign_key :items, :internal_orders, column: :internal_order_id

    # Add indexes
    add_index :items, [:item_id, :company_id], unique: true
  end
end
