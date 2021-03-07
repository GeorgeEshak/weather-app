import Vue from 'vue'
import App from './App.vue'

// Vuesax Component Framework
import Vuesax from 'vuesax'
import 'vuesax/dist/vuesax.css' // Vuesax
Vue.use(Vuesax)

// axios
import axios from './axios.js'
Vue.prototype.$http = axios

import vueGeoloaction from 'vue-browser-geolocation'
Vue.use(vueGeoloaction)

// Styles: SCSS
import './assets/scss/main.scss'

// Tailwind
import '@/assets/css/main.css'

// Vue Router
import router from './router'

Vue.config.productionTip = false

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
