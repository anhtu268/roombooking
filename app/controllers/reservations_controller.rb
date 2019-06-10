class ReservationsController < ApplicationController
  before_action :authenticate_user!, only: %i(create new)
  before_action :must_have_availability_param

  def index
    redirect_to new_location_reservation_url(params.permit(q: {}))
  end

  def create
    @book_room = BookRoom.new(reservations_params, current_user).book
    if @book_room[:reservation].errors.empty? && @book_room[:detail].errors.empty?
      flash[:success] = t ".created"
      redirect_to bill_path(@book_room[:reservation])
    else
      @reservation = @book_room[:reservation]
      @reservation_detail = @book_room[:detail]
      load_rooms
      @rooms = RoomDecorator.decorate_collection @rooms
      render :new
    end
  end

  def new
    load_rooms
    @rooms = RoomDecorator.decorate_collection @rooms
    @reservation = Reservation.new
    @reservation_detail = ReservationDetail.new
  end

  private
  def load_rooms
    @location = Location.find_by id: params[:location_id]
    @rooms = FindAvailabilityRooms.new(@location, params.permit(q: {})).all_records
  end

  def reservations_params
    params.permit({room: {}}, {q: {}}, :location_id)
  end

  def must_have_availability_param
    return true if params[:q]
    flash[:warning] = t "flash.availability"
    redirect_to locations_url
  end
end
