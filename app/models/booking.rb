require "date"

class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flat
  has_many :reviews, dependent: :destroy

  validate :end_date_must_be_after_start_date, :start_date_must_be_after_today

  private

  def end_date_must_be_after_start_date
    errors.add(:end_date, "doit obligatoirement être après la date d'arrivée") if start_date > end_date
  end

  def start_date_must_be_after_today
    errors.add(:end_date, "les dates sont passées !") if Date.today > start_date
  end
end
