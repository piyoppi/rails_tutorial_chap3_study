import Vue from 'vue'
import App from './app.vue'
import Login from './login.vue'
import Users from './users.vue'
import Root from './root.vue'
import VueRouter from 'vue-router'

Vue.config.debug = true;
Vue.use(VueRouter);
Vue.component("root", Root);


const routes = [
    {path: '/user/:id', component: App},
    {path: '/', component: Users},
    {path: '/login', component: Login},
];

const router = new VueRouter({routes});

document.addEventListener('DOMContentLoaded', () => {
    document.body.appendChild(document.createElement('root'))
    let app = new Vue({
        router: router
        //render: c => c(Root)
    }).$mount('root');
})


