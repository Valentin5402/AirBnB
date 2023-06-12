require 'date'

class BookingsController < ApplicationController
  include Pundit

  def index
    @bookings_as_tenant = policy_scope(Booking.where(user_id: current_user.id).order(:start_date))
    @bookings_as_owner = policy_scope(Booking.joins(:flat).where(flats: { user_id: current_user.id }).order(:start_date))
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
    @flat = Flat.find(params[:flat_id])
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.flat = @flat
    authorize @booking
    check = check_available(@booking)
    if check
      redirect_back(fallback_location: flat_path(@booking.flat), notice: "Cet appartement est déjà réservé à ces dates.")
    elsif
      @booking.confirmation = "pending"
      if @booking.save
        redirect_to flat_path(@flat), notice: "La réservation a bien été effectuée !"
        # redirect_back(fallback_location: flat_path(@booking.flat), notice: "La réservation a bien été effectuée !")
      else
        redirect_to flat_path(@flat), notice: "Vous ne pouvez pas demander la réservation à ces dates.", status: :unprocessable_entity
        # redirect_back(fallback_location: flat_path(@booking.flat), notice: "Cet appartement est déjà réservé à ces dates.")
      end
    end
  end

  def edit
    @booking = Booking.find(params[:id])
    @flat = @booking.flat
    authorize @booking
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.confirmation = "pending"
    authorize @booking
    if @booking.update(booking_params)
      # !!! LA NOTICE NE FONCTIONNE PAS MALGRE 2 TENTATIVES DIFFERENTES !!!
      flash[:notice] = "Votre réservation a bien été mise à jour !"
      redirect_to bookings_path(@booking), notice: "Votre réservation a bien été mise à jour !"
    else
      redirect_back(fallback_location: bookings_path(@booking.flat), notice: "Vous ne pouvez pas demander la réservation à ces dates.")
    end
  end

  # !!!!! ESSAI POUR PRENDRE EN COMPTE LA METHODE CHECK EN PRIVATE (EVITER LES SURRESERVATIONS, MAIS CA NE FONCTIONNE PAS !)
  # def update
  #   @flat = Flat.find(params[:flat_id])
  #   @booking = Booking.find(params[:id])
  #   authorize @booking
  #   check = check_available(@booking)
  #   if check
  #     redirect_back(fallback_location: flat_path(@booking.flat), notice: "Cet appartement est déjà réservé à ces dates.")
  #   else
  #     if @booking.update(booking_params)
  #       redirect_to bookings_path(@booking)
  #       flash[:notice] = "La réservation a été mise à jour !"
  #       @booking.confirmation = "pending"
  #     else
  #       redirect_back(fallback_location: flat_path(@booking.flat), notice: "Vous ne pouvez pas demander la réservation à ces dates.")
  #     end
  #   end
  # end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @flat = @booking.flat
    @booking.destroy
    redirect_back(fallback_location: flat_path(@booking.flat), notice: "La réservation a bien été annulée !")
  end

  def accept
    @booking = Booking.find(params[:id])
    @flat = @booking.flat
    check = check_available(@booking)
    authorize @booking
    if !check
      @booking.update(confirmation: "accepted")
      redirect_back(fallback_location: flat_path(@booking.flat), notice: "La réservation a été acceptée !")
    else
      redirect_back(fallback_location: flat_path(@booking.flat), notice: "Vous ne pouvez pas accepter cette réservation")
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
    reservations = Booking.where(flat: booking.flat, confirmation: "accepted")
    reservations.each do |reservation|
      list_of_reservations << [reservation.start_date, reservation.end_date]
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
