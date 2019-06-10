class StaticPagesController < ApplicationController
  def home
    @search = ransack_params
    @locations = Location.popular
    @location_types = LocationType.includes(:locations).order(:name)
  end

  private
  def ransack_params
    Location.ransack params[:q]
  end
end
