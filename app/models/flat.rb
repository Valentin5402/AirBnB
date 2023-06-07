class Flat < ApplicationRecord
  validates :name, presence: true, length: { maximum: 40, too_long: 'Le nom doit faire moins de %{count} caractères' }
  validates :address, presence: true
  validates :description, presence: true
  validates :price_per_night, numericality: { greater_than: 0 }
  validates :number_of_guests, numericality: { greater_than: 0 }
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_many_attached :photos
end
