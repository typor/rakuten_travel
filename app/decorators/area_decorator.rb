module AreaDecorator
  def name
    return short_name unless short_name.blank?
    long_name
  end

  def enable_label
    if enabled
      raw('<span class="label label-info">' + t('global.enabled') + '</span>')
    else
      raw('<span class="label label-warning">' + t('global.disabled') + '</span>')
    end
  end

  def section
    [large, middle, small.blank? ? nil : small, detail.blank? ? nil : detail].compact.join(' / ')
  end
end