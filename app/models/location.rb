class Location < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  belongs_to :user
  belongs_to :location_type

  delegate :name, to: :location_type, prefix: true

  mount_uploaders :pictures, PictureUploader

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }

  validates_presence_of :name, :address, :national, :zip_code, :description

  LOCATION_PARAMS = [:name, :address, :national, :zip_code, :description, :status, :location_type_id, :user_id, :created_at, :updated_at, pictures: []].freeze

  scope :list, (lambda do
    select :id, :name, :address, :national, :zip_code,
      :description, :status, :location_type_id, :user_id, :created_at, :updated_at
  end)

  scope :have_rooms_fit_with, (lambda do |p|
    start_date = p[:range].split(" - ")[0]
    end_date = p[:range].split(" - ")[1]
    peoples = p[:peoples].to_i
    rooms = p[:rooms].to_i
    locations = find_by_sql "SELECT id
      FROM `mini-booking`.locations AS location_left
      LEFT JOIN
          (SELECT SUM(room_left.occupancy_limit * room_right.c_a) AS capacity_used, SUM(room_right.c_a) AS rooms_used, room_left.location_id AS l_id
        FROM `mini-booking`.rooms AS room_left
        JOIN
          (SELECT COUNT(*) AS c_a, room_id AS r_id
          FROM
            (SELECT r_deltails.*
            FROM `mini-booking`.reservation_details AS r_deltails
            JOIN `mini-booking`.reservations AS resers
            ON r_deltails.reservation_id = resers.id
            WHERE r_deltails.start_date <= '#{Time.parse end_date}' AND r_deltails.end_date >= '#{Time.parse start_date}' AND resers.status <= 1) AS ad_orders
          GROUP BY room_id) AS room_right
        ON room_left.id = room_right.r_id
        GROUP BY room_left.location_id) AS location_right
      ON location_left.id = location_right.l_id
      WHERE (rooms_used IS NULL AND (total_capacity - #{peoples}) >= 0 AND (total_rooms - #{rooms}) >= 0)
      OR (capacity_used < (total_capacity - #{peoples}) AND rooms_used < (total_rooms - #{rooms}))
      "
    ids = []
    locations.each {|s| ids << s.id}
    return where(id: ids)
  end)

  def get_reservation_data
    data = []
    7.times do |time|
      count = reservations.where("created_at >= ? AND created_at < ?", time.days.ago.to_date, (time-1).days.ago.to_date).size
      data << {y: "#{time.days.ago.to_date}", a: count}
    end
    return data
  end

  def self.popular
    reservations = Reservation.group(:location_id).where("created_at >= ?", 7.days.ago.to_date).select("location_id AS id, COUNT(*) AS number").order("number DESC").limit(9)
    location_ids = []
    reservations.each {|a| location_ids << a.id}
    return Location.where(id: location_ids)
  end
end
