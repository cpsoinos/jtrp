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
  }
})
