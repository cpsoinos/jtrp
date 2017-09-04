$(document).on('turbolinks:load', function() {

  if (gon.salesMetrics != undefined) {
    initDashboardPageCharts();
  }

  // Dynamically create mark-sold-modals
  $("#item-todo-task-modal").on('shown.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var itemDescription = button.data('itemDescription') // Extract info from data-* attributes
    var itemId = button.data('itemId') // Extract info from data-* attributes
    var itemPhoto = button.data('itemPhoto') // Extract info from data-* attributes
    var itemLink = button.data('itemLink') // Extract info from data-* attributes
    var accountLink = button.data('accountLink') // Extract info from data-* attributes
    var accountItemNumber = button.data('accountItemNumber') // Extract info from data-* attributes
    var jobLink = button.data('jobLink') // Extract info from data-* attributes
    var jobId = button.data('jobId') // Extract info from data-* attributes
    var proposalLink = button.data('proposalLink') // Extract info from data-* attributes
    var proposalId = button.data('proposalId') // Extract info from data-* attributes
    var itemOwnershipType = button.data('itemOwnershipType')
    var taskDescription = button.data('taskDescription')
    var taskLabel = button.data('taskLabel')
    var taskField = button.data('taskField')
    var modal = $(this)
    modal.find('form').attr('action', ('/items/' + itemId));
    modal.find('.modal-title').text(itemDescription);
    modal.find('.item-id').text(itemId);
    modal.find('.item-photo').html(itemPhoto);
    modal.find('.item-link').html(itemLink);
    modal.find('.account-link').html(accountLink);
    modal.find('.account-item-number').text(accountItemNumber);
    modal.find('.job-link').html(jobLink);
    modal.find('.job-id').text(jobId);
    modal.find('.proposal-link').html(proposalLink);
    modal.find('.proposal-id').text(proposalId);
    modal.find('.item-ownership-type').text(itemOwnershipType);
    modal.find('.task-description').text(taskDescription);
    modal.find('.task-label').html(taskLabel);
    modal.find('.task-field').html(taskField);
  });

  $("#agreement-todo-task-modal").on('shown.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var agreementId = button.data('agreementId')
    var accountId = button.data('accountId')
    var agreementLink = button.data('agreementLink')
    var dayCount = button.data('dayCount')
    var unexpireableButton = button.data('unexpireableButton')
    var itemsRetrievedButton = button.data('itemsRetrieved')
    var modal = $(this)
    modal.find('form').attr('action', ('/agreements/'+ agreementId + '/letters'));
    modal.find('.modal-title').html(agreementLink);
    modal.find('.agreement-link').html(agreementLink);
    modal.find('.day-count').text(dayCount);
    modal.find('.unexpireable-button').html(unexpireableButton);
    modal.find('.items-retrieved-button').html(itemsRetrievedButton);
  });

  $("#statement-todo-task-modal").on('shown.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var statementId = button.data('statementId')
    var accountId = button.data('accountId')
    var statementLink = button.data('statementLink')
    var statementSummary = button.data('statementSummary')
    var modal = $(this)
    modal.find('form').attr('action', ('/accounts/' + accountId + '/statements/' + statementId));
    modal.find('.modal-title').html(statementLink);
    modal.find('.statement-summary').html(statementSummary);
  });

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
