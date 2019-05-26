$(document).ready(function() {
  function printChart(data) {
    Morris.Line({
      element: 'reservations_chart',
      data: data,
      xkey: 'y',
      ykeys: ['a'],
      labels: ['Series a']
    });
  }

  function renderChart() {
    $.ajax({
      type: "POST",
      url: document.URL,
      dataType: "json",
      cache: false,
      contentType: "application/json",
      success: function(data) {
        $('#reservations_chart').html('');
        printChart(data);
      },
      error: function(xhr, status, error) {
        alert(xhr.status);
      }
    });
  }

  renderChart();
});
