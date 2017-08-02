<template>
    <div id="users">
        <div id="users_feed_outer">
            <div id="message"> {{ message }} </div>
            <feed-component @get_feed_event="get_feed" :feeds="feeds" :users="users" :page="page"></feed-component>
        </div>
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
            feeds: [],
            users: {},
            page: 0,
            message: ""
        }
    },
    created: function(){
        this.get_feed(0);
    },
    methods: {
        get_feed: function(increment_amount){
            if( this.page >= 0 ) this.page += increment_amount;
            Api.getMyFeed(this.page).then( e=>{ 
                this.feeds = e.data.feed;
                this.users = {};
                e.data.users.forEach( user=>{ this.users[String(user.id)] = user; });
            })
            .catch(e=>{
                this.message = e;
            });
        }
    }
}
</script>

<style scoped>
</style>
