$ ->
  $("a.toggle-link").on('click', (event)->
    event.preventDefault()
    element = $(this)
    $.ajax(url: $(this).attr('href')).done (response)->
      if(response.enabled == undefined)
        $.notify("Something wrong", "error");
      else if(response.enabled == true)
        element.find('span').attr('class', 'label label-info').text(element.data('enabled-label'))
      else
        element.find('span').attr('class', 'label label-warning').text(element.data('disabled-label'))
      $.notify("変更しました。", "success");
  )