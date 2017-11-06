<template lang="pug">
  .accounts-index
    .row
      .col-md-10.col-md-offset-1.col-xs-12
        .row.top-margin
          ul.nav.nav-pills.text-center.justify-list
            li(
              v-for="status in statuses"
              :key='status'
            )
              a(href='/')
                span.icon.icon-info.tab-icon
                  i.material-icons.md-48 assignment_ind
                  h5 {{ status }}
    .large-top-margin
      .row
        .table-responsive
          table.table.table-shopping
            thead
              tr
                th.text-center
                th.text-center.th-description Name
                th.text-center Account No.
                th.text-center Jobs
                th.text-center Items
            tbody
              AccountRow(
                v-for='account in accounts',
                :key='account.id',
                :account='account'
              )
</template>

<script>
  import AccountRow from './row'

  export default {
    name: 'accounts',

    components: {
      AccountRow
    },

    data() {
      return {
        statuses: [
          'potential',
          'active',
          'inactive'
        ],
        accounts: gon.accounts
      }
    }
  }
</script>

<style lang="css">
</style>
