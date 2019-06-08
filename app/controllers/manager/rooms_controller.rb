class Manager::RoomsController < Manager::ApplicationController
  before_action :load_location
  before_action :load_room, except: %i(new index create search)

  def index
    @rooms = @location.rooms.list.page(params[:page]).per(Settings.page).decorate
  end

  def show; end

  def search
    @rooms = SearchService.new(@location.rooms,search_params,Settings.search_fields.room).all_records
      .page(params[:page]).per Settings.page
    render :index
  end

  def new
    @room = @location.rooms.new
  end

  def create
    @room = @location.rooms.new room_params.except(:services)
    @room.services << Service.find(filter_blank_attributes room_params[:services])
    if @room.save
      flash[:success] = t(".created")
      redirect_to manager_location_rooms_path
    else
      flash[:error] = t(".create_unsuccess")
      render :new
    end
  end

  def edit; end

  def update
    if @room.update room_params
      flash[:success] = t(".room_updated")
      redirect_to manager_location_rooms_path
    else
      render :edit
    end
  end

  private

  def room_params
    params.require(:room).permit Room::ROOM_PARAMS
  end

  def search_params
    params.slice :content, :field
  end

  def load_location
    @location = Location.find_by(id: params[:location_id]).decorate
    return if @location
    flash[:error] = t(".location_not_found")
    redirect_to manager_locations_path
  end

  def load_room
    @room = @location.rooms.find_by(id: params[:id]).decorate
    return if @room
    flash[:error] = t(".room_not_found")
    redirect_to manager_location_rooms_path
  end

  def filter_blank_attributes array
    array.reject { |e| e.to_s.empty? }
  end
end
