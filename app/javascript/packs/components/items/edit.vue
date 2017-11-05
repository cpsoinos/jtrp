<template lang="pug">
  .item-form-vue(v-if='item')
    .row
      .col-sm-6
        .form-group.label-floating
          label.control-label Description
          input.form-control(type='text', v-model='item.description')
      .col-sm-6
        select.selectpicker(v-model='item.category_id', data-style='btn btn-primary btn-round', :title='itemCategory().name', data-size='7')
          option(disabled, selected) Choose category
          option(v-for='category in categories', :key='category.id', :value='category.id') {{ category.name }}
    .row
      .col-sm-6
        .form-group.label-floating
          label.control-label Item No.
          input.form-control(type='number', v-model='item.account_item_number')
      .col-sm-6
        .form-group.label-floating
          label.control-label JTRP No.
          input.form-control(type='number', v-model='item.jtrp_number')
    .row
      .col-sm-6
        .form-group.label-floating
          label.control-label Acquired At
          .input-group
            span.input-group-addon
              i.fa.fa-calendar
            date-picker(v-model='item.acquired_at')
      .col-sm-6
        .form-group.label-floating
          label.control-label Condition
          input.form-control(type='text', v-model='item.condition')
    .row
      .col-sm-6
        .form-group.label-floating
          label.control-label Purchase Cost
          .input-group
            span.input-group-addon
              i.fa.fa-usd
            input.form-control(type='text', v-model='item.purchase_price')
      .col-sm-6
        .form-group.label-floating
          label.control-label Labor Cost
          .input-group
            span.input-group-addon
              i.fa.fa-usd
            input.form-control(type='text', v-model='item.labor_cost')
    .row
      .col-sm-6
        .form-group.label-floating
          label.control-label Listing Price
          .input-group
            span.input-group-addon
              i.fa.fa-usd
            input.form-control(type='text', v-model='item.listing_price')
      .col-sm-6
        .form-group.label-floating
          label.control-label Min. Price
          .input-group
            span.input-group-addon
              i.fa.fa-usd
            input.form-control(type='text', v-model='item.minimum_sale_price')
    .row
      .col-sm-6
        .form-group.label-floating
          label.control-label Sale Price
          .input-group
            span.input-group-addon
              i.fa.fa-usd
            input.form-control(type='text', v-model='item.sale_price')
      .col-sm-6
        .form-group.label-floating
          label.control-label Sold At
          .input-group
            span.input-group-addon
              i.fa.fa-calendar
            date-picker(v-model='item.sold_at')

    .row.text-center
      button.btn.btn-raised.btn-primary(type='submit', @click='saveItem')
          | Update Item
</template>

<script>
  import moment from 'moment'
  import _ from 'lodash'

  export default {
    name: 'edit-item-form',

    data() {
      return {
        item: null,
        categories: []
      }
    },

    mounted() {
      this.fetchData()
    },

    methods: {
      fetchData() {
        const element = document.getElementById('item-form-data')
        this.item = JSON.parse(element.dataset.item)
        this.categories = JSON.parse(element.dataset.categories)
        this.item.sold_at = moment(this.item.sold_at)
        this.item.acquired_at = moment(this.item.acquired_at)
        this.item.purchase_price = this.item.purchase_price_cents / 100
        this.item.labor_cost = this.item.labor_cost_cents / 100
        this.item.listing_price = this.item.listing_price_cents / 100
        this.item.minimum_sale_price = this.item.minimum_sale_price_cents / 100
        this.item.sale_price = this.item.sale_price_cents / 100
      },

      itemCategory() {
        return _.find(this.categories, ['id', this.item.category_id])
      },

      saveItem() {
        this.axios.put(`/items/${this.item.id}`, { item: this.item }).then(response => {
          if (response.status === 200) {
            toastr.success('Item successfully updated', 'Success!', { timeOut: 5000 })
          } else {
            toastr.error('There was an error', 'Error', { timeOut: 5000 })
          }
          console.log(response.data)
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
</style>
