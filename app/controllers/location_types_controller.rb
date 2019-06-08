class LocationTypesController < ApplicationController
  before_action :load_location_type, only: %i(show)

  def show
    @locations = @location_type.locations.order(:name).page(params[:page]).per Settings.controllers.static_pages.page
  end

  private
  def location_type_params
    params.require(:location_type).permit :name
  end

  def load_location_type
    @location_type = LocationType.find_by id: params[:id]
    return if @location_type
    flash[:error] = t(".location_type_not_found")
    redirect_to location_types_url
  end
end
