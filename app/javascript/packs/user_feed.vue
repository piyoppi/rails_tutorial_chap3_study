<template>
    <div id="micropost_feed_outer">
        <feed-component @get_feed_event="get_feed" :feeds="microposts" :users="users" :page="page"></feed-component>
    </div>
</template>

<script>
import Api from '../lib/micropost_api.js'
import FeedComponent from './feed_component.vue'
export default {
    components: {
        FeedComponent
    },
    data: function(){
        return{
            microposts: [],
            users: {},
            page: 0,
            user_id: this.$route.params.id
        }
    }
    ,
    created: function(){
        this.get_feed(0);
    },
    methods: {
        get_feed: function(increment_amount){
            if( this.page >= 0 ) this.page += increment_amount;
            Api.getUserMicropost(this.user_id, this.page).then((e) => {
                this.users[String(this.user_id)] = {user_id: this.user_id, name: ""};
                this.microposts = e.data.micropost;
            })
            .catch( e => {
                console.log(e);
            });
        }
    }
}
</script>

<style scoped>
</style>
