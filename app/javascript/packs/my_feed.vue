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
import FeedComponent from './FeedComponent.vue'
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
            try{
                Api.get_own_feed(this.page, (e)=>{ 
                    if(e.result){
                        this.feeds = e.data.feed;
                        this.users = {};
                        e.data.users.forEach( user=>{ this.users[String(user.id)] = user; });
                    }
                    else{
                        this.message = "Session was expired. Please log in.";
                    }
                });
            }
            catch (e){
                this.message = Api.ERR_API_TOKEN_NOT_FOUND;
            }
        }
    }
}
</script>

<style scoped>
</style>
