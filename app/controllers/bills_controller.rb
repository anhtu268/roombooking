class BillsController < ApplicationController
  def index
    @bills = current_user.reservations.includes(:reservation_details).page(params[:page]).per 10
  end

  def show
    @bill = Reservation.find(params[:id])
    @bill_details = @bill.reservation_details
  end

  def pay
    @bill = Reservation.find(params[:id])
    if @bill.update(status: 1)
      flash[:success] = "Pay success!"
      redirect_to bills_url
    else
      render :show
    end
  end
end
