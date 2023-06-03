require 'date'

class BookingsController < ApplicationController
  include Pundit

  def index
    @bookings = policy_scope(Booking.where(user_id: current_user.id))
    authorize @bookings
    @review = Review.new
  end

  def new
    @booking = Booking.new
    @flat = Flat.find(params[:flat_id])
    @booking.user = current_user
    @booking.flat = @flat
    authorize @booking
  end

  def create
    # raise
    @flat = Flat.find(params[:flat_id])
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.flat = @flat
    @booking.confirmation = "pending"
    authorize @booking
    if @booking.save
      redirect_to flat_path(@flat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    @booking = Booking.find(params[:id])
    @booking.update(confirmation: "accepted")
    authorize @booking
    redirect_to bookings_path, notice: "La réservation a été acceptée."
  end

  def refuse
    @booking = Booking.find(params[:id])
    @booking.update(confirmation: "refused")
    authorize @booking
    redirect_to bookings_path, notice: "La réservation a été refusée."
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
