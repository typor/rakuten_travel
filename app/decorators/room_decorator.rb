module RoomDecorator
  def smoking_label
    if smoking
      content_tag(:span, t('global.smoking'), class: "label label-primary")
    else
      content_tag(:span, t('global.not_smoking'), class: "label label-danger")
    end
  end

  def hotel_name
    return 'Invalid hotel' unless hotel

    hotel.short_name.presence || hotel.long_name
  end

  def admin_hotel_link
    link_to hotel_name, admin_hotel_path(hotel)
  end

  def rakuten_hotel_link(label = nil)
    link_to label || hotel_name, hotel.link
  end
end