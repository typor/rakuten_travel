$ ->
  $("a.toggle-link").on('click', (event)->
    event.preventDefault()
    element = $(this)
    $.ajax(url: $(this).attr('href')).done (response)->
      if(response.enabled == undefined)
        alertify.error("エラーが発生しました。");
      else if(response.enabled == true)
        element.find('span').attr('class', 'label label-info').text(element.data('enabled-label'));
        alertify.success("有効にしました。");
      else
        element.find('span').attr('class', 'label label-warning').text(element.data('disabled-label'));
        alertify.success("無効にしました。");
  )