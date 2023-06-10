require 'date'

class BookingsController < ApplicationController
  include Pundit

  def index
    @bookings_as_tenant = policy_scope(Booking.where(user_id: current_user.id))
    @bookings_as_owner = policy_scope(Booking.joins(:flat).where(flats: { user_id: current_user.id }))
    @bookings = @bookings_as_tenant.to_a + @bookings_as_owner.to_a
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
    check = check_available(@booking)
    if !check
      redirect_back(fallback_location: flat_path(@booking.flat), notice: "Vous avez déjà demandé la réservation à ces dates.")
    end
    @booking.confirmation = "pending"
    authorize @booking
    if @booking.save
      redirect_to flat_path(@flat)
      flash[:notice] = "La réservation a bien été effectuée !"
    else
      redirect_back(fallback_location: flat_path(@booking.flat), notice: "Cet appartement est déjà réservé à ces dates.")
    end
  end

  def accept
    @booking = Booking.find(params[:id])
    @flat = @booking.flat
    check = check_available(@booking)
    authorize @booking
    raise
    if !check
      # @booking.update(confirmation: "accepted")
      # redirect_back(fallback_location: flat_path(@booking.flat), notice: "La réservation a été acceptée !")
    else
      # redirect_back(fallback_location: flat_path(@booking.flat), notice: "Vous ne pouvez pas accepter cette réservation")
    end
  end

  def refuse
    @booking = Booking.find(params[:id])
    @booking.update(confirmation: "refused")
    authorize @booking
    redirect_back(fallback_location: flat_path(@booking.flat), notice: "La réservation a été refusée !")
  end

  private

  def check_available(booking)
    check = false
    list_of_reservations = []
    if current_user == @flat.user
      reservations = Booking.where(flat: booking.flat, confirmation: "accepted")
      reservations.each do |reservation|
        list_of_reservations << [reservation.start_date, reservation.end_date]
      end
    end

    if current_user != @flat.user then
      my_reservations = Booking.where(flat: booking.flat, confirmation: "pending", user: current_user)
      my_reservations.each do |reservation|
        list_of_reservations << [reservation.start_date, reservation.end_date]
      end
    end

    list_of_reservations.each do |reservation|
      if (booking.start_date > reservation[0] && booking.start_date < reservation[1]) || (booking.end_date > reservation[0] && booking.end_date < reservation[1]) || (booking.start_date <= reservation[0] && booking.end_date >= reservation[1])
        check = true
        break
      end
    end
    # raise
    return check
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
