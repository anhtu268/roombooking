class LocationsController < ApplicationController
  before_action :set_location, only: :show

  def index
    @search = ransack_params
    @locations = ransack_result
  end

  def show; end

  private
  def set_location
    @location = Location.find_by(id: params[:id]).decorate
    return if @location
    flash[:error] = t(".location_not_found")
    redirect_to locations_path
  end

  def ransack_params
    Location.ransack(params[:q])
  end

  def ransack_result
    if params[:q] && params[:q][:have_rooms_fit_with]
      Location.have_rooms_fit_with(params[:q][:have_rooms_fit_with]).ransack(params[:q]).result.page(params[:page]).per(Settings.controllers.locations.pag)
    else
      @search.result.order(total_rate: :desc)
        .page(params[:page]).per(Settings.controllers.locations.pag)
    end
  end
end
