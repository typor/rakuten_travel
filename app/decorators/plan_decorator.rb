module PlanDecorator

  def hotel_name
    hotel ? hotel.name : ''
  end

  def point_icon
    css_class = point_rate > 1 ? 'label-success' : 'label-info'
    content_tag(:span, point_rate.to_s + '%', class: "label #{css_class}")
  end

  def gift_icon
    content_tag(:span, icon('gift') + '  ' + number_with_delimiter(gift_price), class: 'label label-success') if gift_price >0
  end

  def breakfast_icon
    return '' unless with_breakfast
    build_icon(t('global.with_breakfast'), 'label-primary')
  end

  def dinner_icon
    return '' unless with_dinner
    build_icon(t('global.with_dinner'))
  end

  def payment_icon
    if payment_code == 0
      content_tag(:span, t('global.cash_only'), class: 'label label-warning payment payment-cash')
    elsif payment_code == 1
      content_tag(:span, t('global.cash_and_creditcard'), class: 'label label-default payment payment-cash payment-creditcard')
    else
      content_tag(:span, t('global.creditcard_only'), class: 'label label-warning payment payment-creditcard')
    end
  end

  def charge_label
    min = minimum_charges
    max = maximum_charges
    return '' if min <= 0 && max <= max

    return number_to_currency(max) if min == max

    t = []
    t << number_to_currency(min) if min > 0
    t << number_to_currency(max) if max > 0
    t.join("&#xFF5E;").html_safe
  end

  private

  def build_icon(name, css_class = 'label-primary')
    content_tag(:span, raw(name), class: "label #{css_class}")
  end
end