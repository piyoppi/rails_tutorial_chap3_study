<template>
    <div id="micropost_feed_outer">
        <ul>
            <li v-for="item in microposts">
                {{ item.content }}
                {{ item.created_at }}
            </li>
        </ul>
        <button v-on:click="get_feed(-1)" v-show="page!=0">prev</button>
        <button v-on:click="get_feed(1)">next</button>
    </div>
</template>

<script>
import Api from '../lib/micropost_api.js'
export default {
    data: function(){
        return{
            microposts: [{
                content: "sample",
                created_at: "sample1"
            }],
            page: 0,
            user_id: this.$route.params.id
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
