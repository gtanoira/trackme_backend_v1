class Item < ApplicationRecord

  # Referential Integrity: foreign key
  belongs_to :company
  belongs_to :entity,  class_name: 'Entity', foreign_key: :customer_id
  belongs_to :internal_order

  # ENUM fields declarations (starts with 0 zero)
  enum condition: { 
    new: 'New',
    used: 'Used',
    failed: 'Failed',
    repaired: 'Repaired'
  }
  enum item_type: {
    box: 'Box',
    deco: 'Deco'
  }
  enum status: {
    onHand: 'OnHand',
    inTransit: 'InTransit',
    delivered: 'Delivered',
    deleted: 'Deleted'
  }
  enum unit_length: { 
    cm: 'cm',
    inch: 'inch'
  }
  enum unit_volume: {
    m3: 'm3',
    kg3: 'kg3'
  }
  enum unit_weight: {
    kg: 'kg',
    pounds: 'pounds'
  }

end
