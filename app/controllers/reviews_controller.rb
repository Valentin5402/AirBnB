class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @flat = Flat.where()
    @reviews = Review.all
  end

  def new
  end

  def create
  end

end
