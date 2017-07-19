import Vue from 'vue'
import App from './app.vue'
import Root from './root.vue'
import VueRouter from 'vue-router'

Vue.config.debug = true;
Vue.use(VueRouter);
Vue.component("root", Root);


const routes = [
    {path: '/user/:id', component: App},
];

const router = new VueRouter({routes});

document.addEventListener('DOMContentLoaded', () => {
    document.body.appendChild(document.createElement('root'))
    let app = new Vue({router}).$mount('root');
})


