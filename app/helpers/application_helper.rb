module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s + ' | kengos.jp'
  end

  def edit_link(resouce)
    link_to raw('<i class="glyphicon glyphicon-edit"></i>&nbsp;&nbsp;' + t('views.bootstrap3.global.edit')),
      {action: :edit, id: resouce}, {class: 'btn btn-primary btn-sm'}
  end

  def destroy_link(resouce)
    link_to raw('<i class="glyphicon glyphicon-trash"></i>&nbsp;&nbsp;' + t('views.bootstrap3.global.destroy')),
      {action: :destroy, id: resouce}, class: 'btn btn-danger btn-sm', method: :delete, confirm: t('views.bootstrap3.global.confirm_destroy')
  end
end
