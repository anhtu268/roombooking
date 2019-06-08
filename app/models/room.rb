class Room < ApplicationRecord
  monetize :price_cents

  attr_accessor :availability_rooms, :no_days

  has_many :rooms_services, dependent: :destroy
  has_many :services, through: :rooms_services
  has_many :images, as: :imageable, dependent: :destroy
  has_many :reservation_details
  has_many :reservations, through: :reservation_details
  belongs_to :location
  belongs_to :bed_detail
  accepts_nested_attributes_for :rooms_services
  after_save :total_capacity_and_total_rooms_caculate

  delegate :name, to: :bed_detail, prefix: true

  mount_uploaders :pictures, PictureUploader

  validates_presence_of :name, :occupancy_limit, :living_room, :bed_room,
    :bath_room, :number_of_bed, :quantity


  ROOM_PARAMS = [:location, :name, :occupancy_limit, :living_room, :bed_room,
    :bath_room, :number_of_bed, :quantity, :price, :location_id, :bed_detail_id,
    :created_at, :updated_at, pictures: [], services: []].freeze

  scope :by_location_id, -> (location_id){ where("location_id = ?", location_id) }

  scope :list, (lambda do
    select :id, :name, :occupancy_limit, :quantity, :price_cents, :created_at,
      :updated_at, :status, :price_currency
  end)

  private
  def total_capacity_and_total_rooms_caculate
    total_capacity = location.rooms.sum("occupancy_limit * quantity")
    total_rooms = location.rooms.sum(:quantity)
    location.update(total_capacity: total_capacity, total_rooms: total_rooms)
  end
end
