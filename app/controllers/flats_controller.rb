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
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  def show
    @bookings = Booking.all
    @my_bookings_of_this_flat = []
    @bookings.each do |booking|
      @my_bookings_of_this_flat << booking if booking.user == current_user
    end
    @other_bookings_for_my_flat = []
    @bookings.each do |booking|
      @other_bookings_for_my_flat << booking if @flat.user == current_user
    end
    @marker = [{ lat: @flat.latitude,
                 lng: @flat.longitude,
                 info_window: render_to_string(partial: "info_window", locals: {flat: @flat}),
                 marker_html: render_to_string(partial: "marker")
                 }]
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
    params.require(:flat).permit(:name, :address, :description, :price_per_night, :number_of_guests)
  end
end
