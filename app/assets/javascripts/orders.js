$(document).on('turbolinks:load', function() {

  if (document.getElementById('orders') != null) {

    var orders = new Vue({
      el: '#orders',
      data: {
        orders: [],
        paginate: ['orders']
      },
      methods: {
        fetchOrders: function() {
          this.$http.get('/orders.json').then(response => {
            $("#loader").remove();
            this.orders = response.body;
          }, response => {
            $("#loader").remove();
            alert("error!")
          });
        },
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
    },
    fullName: function (obj) {
      if (typeof obj !== 'undefined') {
        obj.first_name + ' ' + obj.last_name
      }
    }
  }
})
