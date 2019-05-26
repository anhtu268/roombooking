class Manager::ReservationsController < Manager::ApplicationController
  before_action :load_location, except: :get_data
  before_action :load_location_json, only: :get_data
  def index
    @reservations = Reservation.joins(:rooms).where(rooms: {location_id: @location.id}).group(:id).page(params[:page]).per Settings.controllers.manager.reservations.page
  end

  def search
    @reservations = SearchService.new(@location.reservations,search_params,Settings.search_fields.reservation).all_records
      .page(params[:page]).per Settings.controllers.manager.reservations.page
    render :index
  end

  def update
    @reservation = Reservation.find_by id: params[:id]
    @reservation.update status: Settings.controllers.manager.reservations.status
    redirect_to manager_location_reservations_path(@location)
  end

  def get_data
    @data = @location.get_reservation_data
    respond_to do |format|
      format.json {render json: @data}
    end
  end

  private
  def load_location
    @location = Location.find_by id: params[:location_id]
    return if @location
    flash[:error] = t(".location_not_found")
    redirect_to manager_locations_path
  end

  def load_location_json
    @location = Location.find_by id: params[:id]
    return if @location
    flash[:error] = t(".location_not_found")
    redirect_to manager_locations_path
  end
end
