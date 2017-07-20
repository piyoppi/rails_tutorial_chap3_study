<template>
    <div id="login">
        <div id="information">
            {{ message }}
        </div>
        <div id="login_outer">
            Username: <input type="text" v-model="email" />
            Password: <input type="password" v-model="password" />
            <button v-on:click="request_auth()">next</button>
        </div>
    </div>
</template>

<script>
import Api from '../lib/micropost_api.js'
export default {
    data: function(){
        return{
            email: "",
            password: "",
            message: ""
        }
    }
    ,
    created: function(){
    },
    methods: {
        request_auth: function(){
            Api.login(this.email, this.password, e => { console.log(e.message); this.message = e.message });
        }
    }
}
</script>

<style scoped>
</style>
