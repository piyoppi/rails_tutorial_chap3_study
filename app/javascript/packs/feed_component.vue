<template>
    <div id="feed_component">
        <ul>
            <li v-for="item in feeds">
                <div id="user_name">{{ users[item.user_id].name }}</div>
                <div id="item_created_at">{{ item.created_at }}</div>
                {{ item.content }}
            </li>
        </ul>
        <div id="btn_field">
            <button v-on:click="get_feed(-1)" v-show="page!=0">prev</button>
            <button v-on:click="get_feed(1)">next</button>
        </div>
    </div>
</template>
<script>
export default {
    name: "feed-component",
    props: [
        'feeds',
        'users',
        'page',
    ],
    methods: {
        get_feed: function(increment_amount){
            this.$emit('get_feed_event', increment_amount);
        }
    }
}
</script>
<style scoped>
    #user_name{
        color: gray;    
        font-size: 9pt;
    }
    #item_created_at{
        color: gray;
        font-size: 9pt;
        float: right;
    }
    ul{
        list-style-type: none;
    }
    li{
        border-style: dashed;
        border-width: 0 0 1px 0;
        padding: 13px;
        border-color: lightgray;
    }
    li:last-child{
        border-style: none;
    }
    button{
        width: 50px;
        height: 30px;
        display: inline-block;
    }
    #btn_field{
        text-align: center;
    }
</style>
