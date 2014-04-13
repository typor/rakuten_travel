$ ->
  $("a.toggle-link").on('click', (event)->
    event.preventDefault()
    element = $(this)
    $.ajax(url: $(this).attr('href')).done (response)->
      if(response.enabled == undefined)
        alertify.error("Something wrong");
      else if(response.enabled == true)
        element.find('span').attr('class', 'label label-info').text(element.data('enabled-label'))
        alertify.success("有効にしました。");
      else
        element.find('span').attr('class', 'label label-warning').text(element.data('disabled-label'))
        alertify.success("無効にしました。");
  )
  $("a.import-hotel-link").on('ajax:success', (data, response, xhr)->
    if(response.status)
      alertify.success("取込JOB" + response.job_id + ' を登録しました。')
    else
      alertify.error("JOB登録に失敗しました。");
  )