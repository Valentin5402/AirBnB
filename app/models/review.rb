class Review < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  validates :comment, length: { minimum: 6, too_short: '%{count} characters is the minimum allowed' }
  validates :rating, presence: true, numericality: { only_integer: true, in: 0..5 }
end
