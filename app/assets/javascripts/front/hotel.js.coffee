$ ->
  $('#filter input:radio').on 'change', ->
    view = $('#calendar-box').fullCalendar 'getView'
    renderEvent(view)
    $('#calendar-box').fullCalendar 'refetchEvents'

  buildParams = (year, month) ->
    json = {
      "year": year,
      "month": month
    }
    d = $('#filter').serializeArray()
    $.each d, ->
      json[this.name] = this.value || ''
    json

  renderEvent = (view) ->
    year = view.start.getFullYear()
    month = view.start.getMonth()
    if month == 12
      year = year + 1
      month = 1
    else
      month = month + 1

    $.ajax {
      url: $('#calendar-box').data('url'),
      dataType: 'json',
      type: "post",
      data: buildParams(year, month)
    }
    .done (sources)->
      $('#calendar-box').fullCalendar('removeEvents')
      $('#calendar-box').fullCalendar('addEventSource', sources)

  $('#calendar-box').fullCalendar {
    eventSources: [
      {
        url: 'https://www.google.com/calendar/feeds/japanese__ja%40holiday.calendar.google.com/public/basic',
        currentTimezone: 'Asia/Tokyo',
        backgroundColor: '#f00',
        borderColor: '#e00',
        textColor: '#eee'
      }
    ],
    header: {
      left: 'title',
      center: '',
      right: 'prev, next'
    },
    editable: false,
    viewRender: (view, element)->
      renderEvent view
  }