class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flat
  validate :end_date_must_be_after_start_date
  # validate :no_overlap_with_existing_bookings

  private

  def end_date_must_be_after_start_date
    errors.add(:end_date, "must be after the start date") if start_date > end_date
  end

  # def no_overlap_with_existing_bookings
  #   overlapping_bookings = flat.bookings.where.not(id:).where(
  #     "(start_date <= ? AND end_date >= ?)
  #     OR (start_date <= ? AND end_date >= ?)
  #     OR (start_date >= ? AND end_date <= ?)",
  #     start_date, start_date, end_date, end_date, start_date, end_date
  #   )
  #   if overlapping_bookings.exists?
  #     errors.add(:end_date, "Booking overlaps with an existing reservation")
  #   end
  # end
end
