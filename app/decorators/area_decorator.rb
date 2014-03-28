module AreaDecorator
  def enable_label
    if enabled
      raw('<span class="label label-info">有効</span>')
    else
      raw('<span class="label label-warning">無効</span>')
    end
  end
end