class Item < ApplicationRecord

  # Referential Integrity: foreign key
  belongs_to :company
  belongs_to :entity,  class_name: 'Entity', foreign_key: :customer_id
  belongs_to :internal_order

  # ENUM fields declarations (starts with 0 zero)
  enum condition: [ :original, :used, :failed, :repaired ]
  enum item_type: [ :itemBox, :itemDeco ]
  enum status: [ :onHand, :inTransit, :delivered, :deleted ]
  enum unit_length: [ :cm, :inch ]
  enum unit_volume: [ :m3, :kg3 ]
  enum unit_weight: [ :kg, :pounds ]

end
