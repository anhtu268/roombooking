class Manager::LocationsController < Manager::ApplicationController
  before_action :load_location, only: %i(show edit update)

  def show; end

  def new
    @location = Location.new.decorate
  end

  def create
    @location = Location.new location_params.merge user_id: current_user.id
    if @location.save
      flash[:success] = t(".created")
      redirect_to manager_root_path
    else
      flash[:error] = t(".create_unsuccess")
      render :new
    end
  end

  def edit; end

  def update
    if @location.update location_params
      flash[:success] = t(".location_updated")
      redirect_to manager_location_path
    else
      render :edit
    end
  end

  private

  def location_params
    params.require(:location).permit Location::LOCATION_PARAMS
  end

  def search_params
    params.slice :content, :field
  end

  def load_location
    @location = Location.find_by(id: params[:id]).decorate
    return if @location
    flash[:error] = t(".location_not_found")
    redirect_to manager_root_path
  end
end
