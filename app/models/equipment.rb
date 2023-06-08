class Equipment < ApplicationRecord
  has_many :flat_equipments, dependent: :destroy
  has_many :flats, through: :flat_equipments
end
