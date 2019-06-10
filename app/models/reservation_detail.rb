class ReservationDetail < ApplicationRecord
  DATE_TIME_REGEX = /\d{4}\-\d{2}\-\d{2}/

  belongs_to :reservation
  belongs_to :room

  validates :start_date, presence: true, format: {with: DATE_TIME_REGEX}
  validates :end_date, presence: true, format: {with: DATE_TIME_REGEX}
  validate :valid_start_date
  validate :valid_end_date
  validate :valid_days
  validate :valid_room_ready

  def valid_start_date
    errors.add(:start_date, I18n.t("reservation_details.model.valid_start_date")) unless start_date >= Time.now
  end

  def valid_end_date
    errors.add(:end_date, I18n.t("reservation_details.model.valid_end_date")) unless end_date >= Time.now
  end

  def valid_days
    errors.add(:end_date, I18n.t("reservation_details.model.valid_days")) if end_date == start_date
  end

  def valid_room_ready
    errors.add(:room_id, I18n.t("reservation_details.model.valid_room_ready")) if (size_between_time(start_date, end_date) >= room.quantity)
  end

  private
  def size_between_time(start_date, end_date)
    room.reservation_details.joins(:reservation).where("reservations.status <= 1")
      .where("start_date <= ?", end_date).where("end_date >= ?", start_date).size
  end
end
