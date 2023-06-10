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
      flash[:notice] = "La réservation a bien été effectuée !"
    else
      @review = Review.new
      @bookings = Booking.all
      # Je veux afficher mes réservations si je suis sur la page de l'appartement de quelqu'un d'autre
      # Seulement pour celui qui a réservé
      @my_bookings_of_this_flat = @bookings.order(:start_date).select { |booking| booking.user == current_user && booking.flat == @flat }
      # Je veux afficher les réservations d'autres personnes de mon appartement si je suis sur la page de mon appartement
      # Seulement pour le propriétaire de l'appartement
      @other_bookings_for_my_flat = @bookings.order(:start_date).select { |booking| @flat.user == current_user && booking.flat == @flat }
      @past_bookings = @my_bookings_of_this_flat.select { |booking| booking.end_date <= Date.today }
      @reviews = @flat.reviews
      @number_of_reviews = @reviews.size
      @average_rating = @reviews.average(:rating)
      @flat_equipments = @flat.equipments
      @marker = [{ lat: @flat.latitude,
                  lng: @flat.longitude,
                  info_window: render_to_string(partial: "flats/show_info_window", locals: { flat: @flat }),
                  marker_html: render_to_string(partial: "flats/show_marker", locals: { flat: @flat }) }]
      # @booking = Booking.new
      render "flats/show", status: :unprocessable_entity
      flash[:notice] = "Cet appartement est déjà réservé à ces dates."
      # redirect_to flat_path(@flat)
    end
  end

  def accept
    @booking = Booking.find(params[:id])
    authorize @booking
    check = check_available(@booking)
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
    reservations = Booking.where(flat: booking.flat, confirmation: "accepted")
    list_of_reservations = []
    reservations.each do |reservation|
      list_of_reservations << [reservation.start_date, reservation.end_date]
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
