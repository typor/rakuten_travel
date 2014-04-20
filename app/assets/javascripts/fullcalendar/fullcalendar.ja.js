var fullCalendarOptions = fullCalendarOptions || {}
fullCalendarOptions = {
  isRTL: false,
  titleFormat: {
    month: 'yyyy年 MMMM',
    week: "MMM d[ yyyy]{ '&#8212;'[ MMM] d yyyy}",
    day: 'dddd, MMM d, yyyy'
  },
  monthNames: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
  monthNamesShort: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
  dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
  dayNamesShort: ['日','月','火','水','木','金','土']
  buttonText: {
    prev: "<span class='fc-text-arrow'>&lsaquo;</span>",
    next: "<span class='fc-text-arrow'>&rsaquo;</span>",
    prevYear: "<span class='fc-text-arrow'>&laquo;</span>",
    nextYear: "<span class='fc-text-arrow'>&raquo;</span>",
    today: '当日',
    month: '月表示',
    week: '週表示',
    day: '日表示'
  }
};