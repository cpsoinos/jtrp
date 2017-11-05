<template lang="pug">
  tr
    td.text-center
      .img-container
        a(:href='`/accounts/${account.slug}`')
          img.img-rounded.img-responsive.img-raised(:src='account.avatar')
    td.td-name
      a(:href='`/accounts/${account.slug}`') {{ account.inverse_full_name }}
      br
      small Primary Contact:
    td.text-center {{ account.id }}
    td.text-center {{ account.jobs_count }}
    td.text-center {{ items_count() }}
</template>

<script>
  import _ from 'lodash'

  export default {
    name: 'account-row',

    props: [
      'account'
    ],

    methods: {
      items_count() {
        return _.sum(account.proposals, 'item_count')
      }
    }
  }
</script>

<style lang="css">
</style>
