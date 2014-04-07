module PlanDecorator
  def name
    return short_name unless short_name.blank?
    long_name
  end

  def hotel_name
    return 'Invalid hotel' unless hotel

    return hotel.short_name unless hotel.short_name.blank?
    return hotel.long_name
  end

  def point
    raw("<span class=\"badge\">" + point_rate.to_s + "%</span>")
  end

  def icons
    [].tap do |f|
      f << build_icon(t('global.with_dinner')) if with_dinner
      f << build_icon(t('global.with_breakfast')) if with_breakfast
      f << payment_icon
    end
  end

  def payment_icon
    if payment_code == 0
      build_icon(t('global.cash_only'), 'label-danger')
    elsif payment_code == 1
      build_icon(t('global.creditcard_only'), 'label-warning')
    else
      build_icon(t('global.cash_and_creditcard'))
    end
  end

  private

  def build_icon(name, css_class = 'label-primary')
    "<span class=\"label #{css_class}\">" + name + "</span>"
  end
end