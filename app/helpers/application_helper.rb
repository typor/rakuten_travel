module ApplicationHelper
  FLASH_MAP = {
    notice: 'alert-info',
    alert: 'alert-warning',
    error: 'alert-danger'
  }.freeze

  def title(page_title)
    content_for :title, page_title.to_s + ' | kengos.jp'
  end

  def edit_link(resouce)
    link_to raw('<i class="glyphicon glyphicon-edit"></i>&nbsp;&nbsp;' + t('views.bootstrap3.global.edit')),
      {action: :edit, id: resouce}, {class: 'btn btn-primary btn-sm'}
  end

  def destroy_link(resouce)
    link_to raw('<i class="glyphicon glyphicon-trash"></i>&nbsp;&nbsp;' + t('views.bootstrap3.global.destroy')),
      {action: :destroy, id: resouce}, class: 'btn btn-danger btn-sm', method: :delete, data: { confirm: t('views.bootstrap3.global.confirm_destroy') }
  end

  def render_flash_messages
    html = ''
    flash.each do |k,v|
      html << bootstrap_alert_tag(k, v)
    end
    return if html == ''

    raw(content_tag('div', raw(html), class: 'flash'))
  end

  def bootstrap_alert_tag(key, message)
    css_class = FLASH_MAP.key?(key) ? FLASH_MAP[key] : ''
    simple_format(message, {class: 'alert ' + css_class}, wrapper_tag: 'div', sanitize: false)
  end
end
