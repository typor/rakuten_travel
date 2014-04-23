module HotelDecorator
  def image(width = 80, options = {})
    image_tag(hotel_image_url, {width: width, alt: Hotel.human_attribute_name(:hotel_image), class: 'img-responsive'}.merge(options))
  end

  def room_image(width = 80, options = {})
    return '' if room_image_url.blank?
    image_tag(room_image_url, {width: width, alt: Hotel.human_attribute_name(:room_image), class: 'img-responsive'}.merge(options))
  end

  def room_type_label
    Hotel.human_attribute_name(:room_type_count) + ': ' + room_type_count.to_s
  end

  def plan_count_label
    Hotel.human_attribute_name(:plan_count) + ': ' + plan_count.to_s
  end

  def room_num_label
    Hotel.human_attribute_name(:room_num) + ': ' + t('global.rooms', num: room_num)
  end

  def toggle_link
    link_to enable_label, toggle_admin_hotel_path(self, format: :json),
      class: 'toggle-link', data: {'enabled-label' => t('global.enabled'), 'disabled-label' => t('global.disabled')}
  end

  def link
    link_to name, url, target: '_blank', rel: 'nofollow'
  end

  def google_map_url(zoom = 16)
    return nil if latitude.blank? || longitude.blank?
    my = URI.escape(name)
    "https://www.google.com/maps/place/#{my}/@#{latitude},#{longitude},#{zoom}z"
  end

  def enable_label
    if enabled
      raw('<span class="label label-info">' + t('global.enabled') + '</span>')
    else
      raw('<span class="label label-warning">' + t('global.disabled') + '</span>')
    end
  end

  def review_score
    return '' if review_average == 0
    bar = review_progressbar
    score = (review_average.to_f / 100.0).to_s
    review_link_label = Hotel.human_attribute_name(:review_count) + ': ' + content_tag(:span, review_count, itemprop: 'reivewCount')
    review_link = link_to raw(review_link_label), review_url, target: '_blank'
    <<-"EOS".html_safe
<div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
  <span>#{review_link}</span>
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