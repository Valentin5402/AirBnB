class FlatsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :set_flat, only: [:show, :edit, :update, :destroy]

  def index
    @flats = policy_scope(Flat)
    @markers = @flats.geocoded.map do |flat|
      {
        lat: flat.latitude,
        lng: flat.longitude,
        info_window: render_to_string(partial: "info_window", locals: {flat: flat}),
        marker_html: render_to_string(partial: "marker", locals: {flat: flat})
      }
    end
  end

  def show
    @bookings = Booking.all
    # Je veux afficher mes réservations si je suis sur la page de l'appartement de quelqu'un d'autre
    # Seulement pour celui qui a réservé
    @my_bookings_of_this_flat = @bookings.select { |booking| booking.user == current_user && booking.flat == @flat }
    # Je veux afficher les réservations d'autres personnes de mon appartement si je suis sur la page de mon appartement
    # Seulement pour le propriétaire de l'appartement
    @other_bookings_for_my_flat = @bookings.select { |booking| @flat.user == current_user && booking.flat == @flat }
    @reviews = @flat.reviews
    @count_of_reviews = @reviews.size
    @average_rating = @reviews.average(:rating)
    @marker = [{ lat: @flat.latitude,
                 lng: @flat.longitude,
                 info_window: render_to_string(partial: "info_window", locals: {flat: @flat}),
                 marker_html: render_to_string(partial: "marker", locals: {flat: @flat}) }]
  end

  def new
    @flat = Flat.new
    authorize @flat
  end

  def create
    @flat = Flat.new(params_flat)
    @flat.user = current_user
    authorize @flat
    if @flat.save
      redirect_to flats_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @flat.update(params_flat)
      redirect_to flat_path(@flat)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @flat.destroy
    redirect_to flats_path
  end

  private

  def set_flat
    @flat = Flat.find(params[:id])
    authorize @flat
  end

  def params_flat
    params.require(:flat).permit(:name, :address, :description, :price_per_night, :number_of_guests, photos: [])
  end
end
