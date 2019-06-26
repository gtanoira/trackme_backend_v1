class AddEnumsToItems < ActiveRecord::Migration[5.2]
  def change

    # ENUMS fields integrity
    reversible do |dir|
      dir.up do
        # Populate the ENUM fields
        execute <<-SQL
          ALTER TABLE items MODIFY `condition`   enum('New', 'Used', 'Failed', 'Repaired') NOT NULL DEFAULT 'New' COMMENT 'Item type: new, used, etc. (enum)',
                            MODIFY `item_type`   enum('Box', 'Deco') NOT NULL DEFAULT 'Box' COMMENT 'Determines the type of content of the Item (enum)',
                            MODIFY `status`      enum('OnHand', 'InTransit', 'Delivered', 'Deleted') NOT NULL DEFAULT 'OnHand' COMMENT 'Specifies the actual status of the item in the process of delivering (enum)',
                            MODIFY `unit_length` enum('cm', 'inch') NOT NULL DEFAULT 'cm' COMMENT 'Unit of measure for distance (enum)',
                            MODIFY `unit_volume` enum('m3', 'kg3') NOT NULL DEFAULT 'm3' COMMENT 'Unit of measure for volume weight (enum)',
                            MODIFY `unit_weight` enum('kg', 'pounds') NOT NULL DEFAULT 'kg' COMMENT 'Unit of measure for weight (enum)';
        SQL
      end
      dir.down do
        change_column :items, :condition,   :string, comment: 'Item type: new, used, etc. (enum)'
        change_column :items, :item_type,   :string, comment: 'Determines the type of content of the Item (enum)'
        change_column :items, :status,      :string, comment: 'Specifies the actual status of the item in the process of delivering (enum)'
        change_column :items, :unit_length, :string, comment: 'Unit of measure for distance (enum)'
        change_column :items, :unit_volume, :string, comment: 'Unit of measure for volume weight (enum)'
        change_column :items, :unit_weight, :string, comment: 'Unit of measure for weight (enum)'
      end
    end
  end
end
