class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @reviews = Review.all
    authorize @review
  end

  # def new
  #   @review = Review.new
  #   authorize @review
  # end

  def create
    @flat = Flat.find(params[:flat_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.booking_id = Booking.where(flat_id: params['flat_id'], user_id: current_user.id)[0].id
    authorize @review
    if @review.save
      redirect_to flat_path(params['flat_id'])
    else # ATTENTION A CORRIGER, il n'y a pas les erreurs de validation
      render 'flats/show(@flat)', status: :unprocessable_entity
      # @bookings = policy_scope(Booking.where(user_id: current_user.id))
      # render 'bookings/index', status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating, :booking_id, :user)
  end
end
