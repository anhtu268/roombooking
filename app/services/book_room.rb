class BookRoom
  def initialize params, user
    @location_id = params[:location_id]
    @room_params = params[:room]
    caculate_start_end params[:q][:have_rooms_fit_with][:range]
    caculate_days
    @user = user
    @total_bill = 0.0
  end

  def book
    if check_number?
      begin
        do_transaction
      rescue ActiveRecord::RecordInvalid
        {reservation: @reservation, detail: @reservation_detail}
      end
      {reservation: @reservation, detail: @reservation_detail}
    else
      {reservation: Reservation.new, detail: @reservation_detail}
    end
  end

  private
  def do_transaction
    ActiveRecord::Base.transaction do
      @reservation = @user.reservations.create!(location_id: @location_id)
      create_reservation_details
      caculate_total_bill @reservation
      @reservation.update! total_bill: @total_bill
    end
  end

  def integer_filter string
    Integer(string || '')
  rescue ArgumentError
    0
  end

  def create_reservation_details
    @room_params.each do |room_id, no_rooms|
      integer_filter(no_rooms).times do
        @room = Location.find(@location_id).rooms.find(room_id)
        @reservation_detail = @room.reservation_details.new(reservation_id: @reservation.id,
          start_date: @start_date, end_date: @end_date)
        @reservation_detail.save!
      end
    end
  end

  def caculate_total_bill reservation
    reservation.reservation_details.each do |res|
      @total_bill += (res.room.price * @days)
    end
  end

  def check_number?
    @room_params.each do |room_id, no_rooms|
      return true if integer_filter(no_rooms) > 0
    end
    @reservation_detail = ReservationDetail.new
    @reservation_detail.errors.add(:room_id, t("services.book_room.check_number"))
    false
  end

  def caculate_days
    @days = (Date.parse(@end_date) - Date.parse(@start_date)).to_i
  end

  def caculate_start_end range
    @start_date = range.split(" - ")[0]
    @end_date = range.split(" - ")[1]
  end
end
