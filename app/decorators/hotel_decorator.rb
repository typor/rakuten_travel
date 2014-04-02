module HotelDecorator
  def image(width = 80)
    image_tag(image_url, width: width, class: 'img-responsive')
  end

  def name
    return short_name unless short_name.blank?
    long_name
  end

  def link
    link_to name, url, target: '_blank'
  end

  def full_address
    hotel.address1 + address2
  end

  def google_map_link(params = {})
    return nil if latitude.blank? || longitude.blank?
    params = {
      name: t('global.google_map_link_name')
    }.merge(params)
    my = URI.escape(name)
    link_to params[:name], "https://maps.google.co.jp/maps?q=loc:#{latitude},#{longitude}", target: '_blank'
  end

  def enable_label
    if enabled
      raw('<span class="label label-info">' + t('global.enabled') + '</span>')
    else
      raw('<span class="label label-warning">' + t('global.disabled') + '</span>')
    end
  end
end