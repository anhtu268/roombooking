module ReservationDecorator
  include ActionView::Helpers

  def status_tag
    case status
    when 0
      {name: "pending", class: "badge badge-warning"}
    when 1
      {name: "paid", class: "badge badge-primary"}
    when 2
      {name: "refused", class: "badge badge-danger"}
    end
  end
end
