<template>
    <div id="feed_component">
        <ul>
            <li v-for="item in feeds">
                {{ users[item.user_id].name }}
                {{ item.content }}
                {{ item.created_at }}
            </li>
        </ul>
        <button v-on:click="get_feed(-1)" v-show="page!=0">prev</button>
        <button v-on:click="get_feed(1)">next</button>
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
