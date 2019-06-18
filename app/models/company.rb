class Company < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :country, class_name: 'IsoCountry'
end
