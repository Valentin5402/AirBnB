class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @reviews = Review.all
    authorize @review
  end

  def new
    @review = Review.new
    authorize @review
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.booking_id = 1 # ATTENTION A CORRIGER
    authorize @review
    if @review.save
      redirect_to flats_path
    else
      # @bookings = policy_scope(Booking.where(user_id: current_user.id))
      # render 'bookings/index', status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating, :booking_id, :user)
  end
end
