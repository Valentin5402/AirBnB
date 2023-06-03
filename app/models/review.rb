class Review < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  validates :comment, length: { minimum: 6, too_long: '%{count} characters is the minimum allowed' }
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
end
