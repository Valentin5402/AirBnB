require "date"

class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flat
  has_many :reviews, dependent: :destroy

  validate :end_date_must_be_after_start_date, :start_date_must_be_after_today, :check_available

  private

  def end_date_must_be_after_start_date
    errors.add(:end_date, "doit obligatoirement être après la date d'arrivée") if start_date > end_date
  end

  def start_date_must_be_after_today
    errors.add(:end_date, "les dates sont passées !") if Date.today > start_date
  end

  def check_available
    check = false
    reservations = Booking.where(flat: flat, confirmation: "accepted")
    listReservation = Array.new
    reservations.each do |reservation|
      listReservation << [reservation.start_date, reservation.end_date]
    end
    check = false
    listReservation.each do |reservation|
      if (start_date >= reservation[0] && start_date < reservation[1]) || (end_date >= reservation[0] && end_date < reservation[1]) || (start_date <= reservation[0] && end_date >=reservation[1] )
        check = true
        break
      end
    end
    # raise
    errors.add(:start_date, "Vous ne pouvez pas réserver cet appartement pendant ces temps.") if check
    errors.add(:end_date, "Vous ne pouvez pas réserver cet appartement pendant ces temps.") if check
  end
end
