module HotelDecorator
  def image(width = 80)
    image_tag(hotel_image_url, width: width, class: 'img-responsive')
  end

  def toggle_link
    link_to enable_label, toggle_admin_hotel_path(self, format: :json),
      class: 'toggle-link', data: {'enabled-label' => t('global.enabled'), 'disabled-label' => t('global.disabled')}
  end

  def link
    link_to name, url, target: '_blank'
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

  def room_num_label
    t('global.rooms', num: room_num)
  end

  def review_score
    bar = review_progressbar
    score = (review_average.to_f / 100.0).to_s
    review_link_label = Hotel.human_attribute_name(:review_count) + ' ' + content_tag(:span, review_count, itemprop: 'reivewCount')
    review_link = link_to raw(review_link_label), review_url, target: '_blank'
    <<-"EOS".html_safe
<div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
  <h5>評価 (#{review_link})</h5>
  <meta itemprop="worstRating" content="1">
  #{bar}
  <meta itemprop="ratingValue" content="#{score}">
</div>
    EOS
  end

  def review_progressbar
    progressbar(review_average, Hotel.human_attribute_name(:review_average))
  end

  def service_progressbar
    progressbar(service_average, Hotel.human_attribute_name(:service_average))
  end

  def location_progressbar
    progressbar(location_average, Hotel.human_attribute_name(:location_average))
  end

  def room_progressbar
    progressbar(room_average, Hotel.human_attribute_name(:room_average))
  end

  def equipment_progressbar
    progressbar(equipment_average, Hotel.human_attribute_name(:equipment_average))
  end

  def bath_progressbar
    progressbar(bath_average, Hotel.human_attribute_name(:bath_average))
  end

  def meal_progressbar
    progressbar(meal_average, Hotel.human_attribute_name(:meal_average))
  end

  def progressbar(value, name)
    return if value == 0
    width = ((value.to_f / 500.0) * 100).to_s + '%'
    score = ((value.to_f / 100.0)).to_s
    css_class = "progress-bar " + progressbar_css(value)
    bar = content_tag(:div, "#{name}: #{score}", role: 'progressbar', class: css_class, 'area-value' => value, 'area-valuemin' => 0, 'area-valuemax' => 500, style: 'text-align:left; padding-left: 1em; width: ' + width)
    content_tag(:div, raw(bar), class: 'progress')
  end

  def progressbar_css(value)
    c = ''
    if value < 200
      c = 'danger'
    elsif value >= 200 && value < 300
      c = 'warning'
    elsif value >= 300 && value < 400
      c = 'info'
    else
      c = 'success'
    end

    'progress-bar-' + c
  end
end