class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flat
  has_many :reviews, dependent: :destroy

  validate :end_date_must_be_after_start_date

  private

  def end_date_must_be_after_start_date
    errors.add(:end_date, "must be after the start date") if start_date > end_date
  end
end
