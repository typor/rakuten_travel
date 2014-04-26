module ApplicationHelper
  FLASH_MAP = {
    notice: 'alert-info',
    alert: 'alert-warning',
    error: 'alert-danger'
  }.freeze

  # @override
  def content_for(name, content = nil, &block)
    @has_content ||= {}
    @has_content[name] = true
    super(name, content, &block)
  end

  def has_content?(name)
    (@has_content && @has_content[name]) || false
  end

  def title(page_title)
    content_for :title, page_title.to_s + ' | ' + site_title
  end

  def site_title
    Settings.site_title rescue ''
  end

  def javascript_include_tag_to(pos, filename)
    content_for pos, javascript_include_tag(filename)
  end

  def stylesheet_link_tag_to(pos, filename)
    content_for pos, stylesheet_link_tag(filename)
  end

  def show_link(resource)
    link_to raw('<i class="fa fa-info-circle"></i>&nbsp;&nbsp;' + t('views.bootstrap3.global.show')),
      {action: :show, id: resource}, {class: 'btn btn-info btn-sm'}
  end

  def edit_link(resource)
    link_to raw('<i class="fa fa-edit"></i>&nbsp;&nbsp;' + t('views.bootstrap3.global.edit')),
      {action: :edit, id: resource}, {class: 'btn btn-primary btn-sm'}
  end

  def destroy_link(resource)
    link_to raw('<i class="fa fa-trash-o"></i>&nbsp;&nbsp;' + t('views.bootstrap3.global.destroy')),
      {action: :destroy, id: resource}, class: 'btn btn-danger btn-sm', method: :delete, data: { confirm: t('views.bootstrap3.global.confirm_destroy') }
  end

  def nav_content_tag(tag, urls, css_class = 'active', options = {}, &block)
    css = current_urls?(urls) ? css_class : ''
    content_tag(tag, {class: css}.merge(options), &block)
  end

  def current_urls?(urls)
    if urls.kind_of?(String) || urls.kind_of?(Symbol)
      return params[:action] == urls.to_s
    end

    if urls.kind_of?(Hash)
      return false if urls[:action].present? && urls[:action].to_s != params[:action]
      return true if urls[:controller].nil?
      return urls[:controller].present? && urls[:controller].to_s == params[:controller]
    end

    if urls.kind_of?(Array)
      urls.each do |f|
        if f.kind_of?(String) || f.kind_of?(Symbol)
          next if f.to_s != params[:action]
        elsif f.kind_of?(Hash)
          # todo
          next if f[:action].to_s != params[:action] || f[:controller].present? && f[:controller].to_s != params[:controller]
        else
          next
        end
        return true
      end
    end

    false
  end

  def controller?(*controllers)
    controllers.include?(params[:controller])
  end

  def action?(*actions)
    actions.include?(params[:action])
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

  def horizontal_form_for(resource, options = {}, &block)
    options = {layout: :horizontal, label_col: 'col-md-2', control_col: 'col-md-6'}.merge! options
    unless options.key? :url
      options[:url] = resource.new_record? ? url_for(action: :create) : url_for(action: :update, id: resource.id)
    end
    bootstrap_form_for(resource, options, &block)
  end

  def google_analytics_tag(&block)
    code = Settings.google_analytics rescue nil
    return '' if code.blank?
    <<-"EOS".html_safe
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', '#{code}', 'auto');
ga('send', 'pageview');
</script>
    EOS
  end

end
