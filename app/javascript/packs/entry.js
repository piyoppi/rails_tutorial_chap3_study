import Vue from 'vue'
import UserFeed from './user_feed.vue'
import Login from './login.vue'
import Users from './users.vue'
import Root from './root.vue'
import VueRouter from 'vue-router'

Vue.config.debug = true;
Vue.use(VueRouter);
Vue.component("root", Root);


const routes = [
    {path: '/m/user/:id', component: UserFeed},
    {path: '/m/', component: Users},
    {path: '/m/login', component: Login},
];

const router = new VueRouter({
    mode: 'history',
    routes: routes
});

document.addEventListener('DOMContentLoaded', () => {
    document.body.appendChild(document.createElement('root'))
    let app = new Vue({
        router: router
    }).$mount('root');
    console.log( app );
})


