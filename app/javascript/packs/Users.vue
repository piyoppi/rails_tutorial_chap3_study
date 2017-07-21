<template>
  <div id="users">
    <div id="users_feed_outer">
        <div id="message"> {{ message }} </div>
        <ul>
            <li v-for="item in users">
                <router-link :to="{ name: 'userfeed', params: { id: item.id }}"> {{ item.name }} </router-link>
            </li>
        </ul>
        <div id="btn_field">
            <button v-on:click="get_users(-1)" v-show="page!=0">prev</button>
            <button v-on:click="get_users(1)">next</button>
        </div>
    </div>
  </div>
</template>

<script>
import Api from '../lib/micropost_api.js'
export default {
    data: function(){
        return{
            users: [],
            page: 0,
            message: ""
        }
    },
    created: function(){
        this.get_users(0);
    },
    methods: {
        get_users: function(increment_amount){
            if( this.page >= 0 ) this.page += increment_amount;
            Api.getUsers(this.page).then(e=>{ 
                this.users = e.data.users;
            })
            .catch (e=>{
                this.message = e;
            });
        }
    }
}
</script>

<style scoped>
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
