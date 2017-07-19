<template>
  <div id="users">
      <div id="users_feed_outer">
          <ul>
              <li v-for="item in users">
              </li>
          </ul>
          <button v-on:click="get_feed(-1)" v-show="page!=0">prev</button>
          <button v-on:click="get_feed(1)">next</button>
      </div>
  </div>
</template>

<script>
import Api from './api.js'
export default {
    data: function(){
            return{
                users: [{
                }],
                page: 0,
            }
        }
    ,
    created: function(){
        Api.get_user_micropost(this.user_id, this.page, (e)=>{ this.microposts = e } );
    },
    methods: {
        get_feed: function(increment_amount){
            if( this.page >= 0 ) this.page += increment_amount;
            Api.get_user_micropost(this.user_id, this.page, (e)=>{ this.microposts = e } );
        }
    }
}
</script>

<style scoped>
</style>
