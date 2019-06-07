class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i(create)
  before_action :load_review, only: %i(destroy)

  def create
    @review = current_user.reviews.create(review_params)
    if @review.save
      flash[:success] = t(".created")
      redirect_to @review.location
    else
      flash[:error] = t(".create_unsuccess")
      redirect_to @review.location
    end
  end

  def destroy
    location = @review.location
    if @review.destroy
      flash[:success] = t(".destroy_success")
    else
      flash[:danger] = t(".destroy_fail")
    end
    redirect_to location
  end

  private
    def load_review
      @review = Review.find_by id: params[:id]
      return if @review
      flash[:error] = t(".review_not_found")
      redirect_to reviews_url
    end

    def review_params
      params.require(:review).permit Review::REVIEW_PARAMS
    end
end
