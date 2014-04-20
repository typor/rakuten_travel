$ ->
  $portfolio = $('.portfolio-items');
  $portfolio.isotope({
    itemSelector: 'li',
    layoutMode: 'fitRows'
  });