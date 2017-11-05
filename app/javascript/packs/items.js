import Vue from 'vue'
import EditItems from './components/items/edit.vue'

import datePicker from 'vue-bootstrap-datetimepicker';
Vue.use(datePicker)

import axios from 'axios'
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios)

document.addEventListener('turbolinks:load', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  axios.defaults.headers.common['X-CSRF-Token'] = token
  axios.defaults.headers.common['Accept'] = 'application/json'

  const element = document.getElementById('item-form')
  const app = new Vue(EditItems).$mount(element)

  console.log(app)
})
