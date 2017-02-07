$(document).on('turbolinks:load', function() {

  if (document.getElementById('orders') != null) {

    var orders = new Vue({
      el: '#orders',
      data: {
        orders: []
      },
      methods: {
        fetchOrders: function() {
          var that;
          that = this;
          $.ajax({
            url: '/orders.json',
            success: function(res) {
              that.orders = res;
            }
          });
        },
        moment: function () {
          return moment();
        }
      }
    });

    orders.fetchOrders();
  }

});

Vue.component('order-row', {
  template: '#order-row',
  props: {
    order: Object
  },
  filters: {
    moment: function (date) {
      return moment(date).format('MMMM Do YYYY, h:mm a');
    },
    currency: function (cents) {
      return '$' + (parseInt(cents) / 100).toFixed(2);
    }
  }
})
