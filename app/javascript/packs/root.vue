<template>
    <div id="root">
        <p>
        <router-link to="/m">My feed</router-link>
        <router-link to="/m/users">Users</router-link>
        <router-link to="/m/login">Login</router-link>
        </p>
        <router-view></router-view>
    </div>
</template>
