<template>
    <div id="root">
        <p>
            <router-link class="menu" :to="{name: 'myfeed'}">My feed</router-link>
            <router-link class="menu" :to="{name: 'users'}">Users</router-link>
            <router-link class="menu" :to="{name: 'login'}">Login</router-link>
        </p>
        <router-view></router-view>
    </div>
</template>
<style>
    .menu{
        border-style: solid;
        padding: 10px 20px;
        border-width: 1px;
        border-radius: 5px 5px 0 0;
        text-decoration: none;
        color: blue;
        margin: 0;
    }
</style>
