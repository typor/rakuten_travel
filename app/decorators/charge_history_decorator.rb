module ChargeHistoryDecorator
  def researched
    l researched_at
  end

  def stay_label
    if can_stay
      raw('<span class="label label-info">' + t('global.can_stay') + '</span>')
    else
      raw('<span class="label label-danger">' + t('global.cannot_stay') + '</span>')
    end
  end

  def price
    number_to_currency amount
  end
end