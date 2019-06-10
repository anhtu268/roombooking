$(function(){
  $("#q_rooms_price_gteq").val('50');
  $("#q_rooms_price_lteq").val('200');

  $("#slider-range").slider({
    range: true,
    min: 0,
    max: 400,
    values: [50, 200],
    slide: function(event,ui){
      $("#q_rooms_price_gteq").val(ui.values[0]);
      $("#q_rooms_price_lteq").val(ui.values[1]);
    }
  });

  $(".ui-widget-header").css('background', '#38a4ff');
  $(".ui-state-default, .ui-widget-content").css('background', 'white');
  $(".ui-state-default, .ui-widget-content").css('border-color', '#38a4ff');
  $(".ui-widget-content").css('width', '100%');
})
