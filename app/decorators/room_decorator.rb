class RoomDecorator < ApplicationDecorator
  delegate_all

  def select_option
    Location.pluck :name
  end

  def status_tag
    return {name: I18n.t("decorators.room.activated"),class: "badge badge-success"} if status
    {name: I18n.t("decorators.room.non_activated"),class: "badge badge-dark"}
  end

  def bed_detail_option
    BedDetail.option_list.collect {|p| [ p.name, p.id ] }
  end

  def service_option
    Service.option_list.collect {|p| [ p.name, p.id ] }
  end

  def book_select range
    options = "<option value=0 selected>0 rooms ($0)</option>"
    value = 0
    object.availability_rooms.times do
      value += 1
      total_prices = h.humanized_money_with_symbol(price_for(range) * value)
      options << "<option value=#{value}>#{value} rooms (#{total_prices})</option>"
    end
    return options
  end

  def price_for range
    h.day_between(range) * object.price
  end
end
