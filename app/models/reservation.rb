class Reservation < ApplicationRecord
  include ReservationDecorator
  monetize :total_bill_cents

  has_many :reservation_details, dependent: :destroy
  has_many :rooms, through: :reservation_details
  belongs_to :user
  belongs_to :location
end
