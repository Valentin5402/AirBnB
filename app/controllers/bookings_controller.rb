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
    # raise
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
    authorize @booking
    check = check_available(@booking)
    # raise
    if !check
      @booking.update(confirmation: "accepted")
      redirect_to bookings_path, notice: "La réservation a bien été acceptée."
    else
      redirect_to bookings_path, notice: "Votre appartement est déja réservé pendant ces temps"
    end
  end

  def refuse
    @booking = Booking.find(params[:id])
    @booking.update(confirmation: "refused")
    authorize @booking
    # ! En fonction de la page sur laquelle l'utilisateur se trouve, rediriger vers le bon chemin (comment faire ?)
    redirect_to bookings_path, notice: "La réservation a été refusée !"
  end

  private

  def check_available(booking)
    check = false
    reservations = Booking.where(flat: booking.flat, confirmation: "accepted")
    listReservation = Array.new
    reservations.each do |reservation|
      listReservation << [reservation.start_date, reservation.end_date]
    end
    listReservation.each do |reservation|
      if (booking.start_date >= reservation[0] && booking.start_date < reservation[1]) || (booking.end_date >= reservation[0] && booking.end_date < reservation[1]) || (booking.start_date <= reservation[0] && booking.end_date >=reservation[1] )
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
