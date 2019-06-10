class StaticPagesController < ApplicationController
  def home
    @search = ransack_params
    @locations = ransack_result
    @location_types = LocationType.includes(:locations).order(:name)
  end

  private
  def ransack_params
    Location.ransack params[:q]
  end

  def ransack_result
    if params[:q]
      Kaminari.paginate_array(@search.result.includes(:location_type, :rooms).have_rooms_fit_with(params[:q][:have_rooms_fit_with]))
        .page(params[:page]).per(Settings.controllers.static_pages.limit_location).decorate
    else
      @search.result.includes(:location_type, :rooms).order(total_rate: :desc)
        .page(params[:page]).per(Settings.controllers.static_pages.limit_location).decorate
    end
  end
end
