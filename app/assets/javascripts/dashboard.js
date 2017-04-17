$(document).on('turbolinks:load', function() {

  initDashboardPageCharts();

});

var type = ['', 'info', 'success', 'warning', 'danger'];

var initDashboardPageCharts = function() {

  /* ----------==========     Daily Sales Chart initialization    ==========---------- */

  var salesMetrics = JSON.parse(gon.salesMetrics);
  var dataDailySalesChart = {
    labels: salesMetrics.labels,
    series: [
      salesMetrics.series
    ]
  };

  var optionsDailySalesChart = {
    lineSmooth: Chartist.Interpolation.cardinal({
      tension: 0
    }),
    low: 0,
    high: 1200, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
    chartPadding: {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    },
  }

  var dailySalesChart = new Chartist.Line('#dailySalesChart', dataDailySalesChart, optionsDailySalesChart);

  md.startAnimationForLineChart(dailySalesChart);



  /* ----------==========     Completed Tasks Chart initialization    ==========---------- */

  var customerMetrics = JSON.parse(gon.customerMetrics)
  var dataCustomerMetricsChart = {
    labels: customerMetrics.labels,
    series: [
      customerMetrics.series
    ]
  };

  optionsCustomerMetricsChart = {
    lineSmooth: Chartist.Interpolation.cardinal({
      tension: 0
    }),
    low: 0,
    high: 12, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
    chartPadding: {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    }
  }

  var customerMetricsChart = new Chartist.Line('#customerMetricsChart', dataCustomerMetricsChart, optionsCustomerMetricsChart);

  // start animation for the Completed Tasks Chart - Line Chart
  md.startAnimationForLineChart(customerMetricsChart);



  /* ----------==========     Emails Subscription Chart initialization    ==========---------- */

  var clientMetrics = JSON.parse(gon.clientMetrics)
  var dataClientMetricsChart = {
    labels: clientMetrics.labels,
    series: [
      clientMetrics.series
    ]
  };

  optionsClientMetricsChart = {
    lineSmooth: Chartist.Interpolation.cardinal({
      tension: 0
    }),
    low: 0,
    high: 50, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
    chartPadding: {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    }
  }

  var clientMetricsChart = new Chartist.Line('#clientMetricsChart', dataClientMetricsChart, optionsClientMetricsChart);

  // start animation for the Completed Tasks Chart - Line Chart
  md.startAnimationForLineChart(clientMetricsChart);

}
