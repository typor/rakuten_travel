$ ->
  $('#calendar-box').fullCalendar({
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
    viewDisplay: (view)->
      $.ajax({
        url: $('#calendar-box').data('url'),
        dataType: 'json',
        type: "get",
        data: {
          "year": view.start.getFullYear(),
          'month': view.start.getMonth() + 1
        }
      }).done (sources)->
        $('#calendar-box').fullCalendar('removeEvents');
        $('#calendar-box').fullCalendar('addEventSource', sources);
  });
