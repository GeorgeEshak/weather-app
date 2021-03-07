<template>
  <div class="" id="page-login">
    <div class="bg-img h-screen text-white flex w-full vx-row no-gutter items-center justify-center">
      <vs-navbar class="px-0 w-3/4 vx-navbar navbar-custom navbar-skelton">
        <div class="flex w-full">
          <h2 class="uppercase text-white mt-2 font-bold">InstaWeather</h2>
          <div class="flex text-right ml-auto">
            <div class="bg-transparent flex mb-4 cursor-pointer p-2 d-theme-dark-bg 
              items-center justify-center hover:shadow-drop"
              v-for="(status, index) in degrees" :key="index" 
              @click="filter = status"
              v-bind:class="index === 0  ? 'border-0 border-r-2 border-solid' : ''"
              :style="customStyle(status)">
              <div class="flex-box flex items-center mr-4">
                <span class="font-semibold text-lg">{{status}}</span>
              </div>
            </div>
          </div>
        </div>
      </vs-navbar>
      <div class="flex w-3/4">
        <div class="block mb-base">
          <h2 class="text-white mb-4 font-bold text-4xl">
            <span v-for="item in city" :key="item.index">{{item}} </span></h2>
          <p class="font-bold mb-base">{{days[new Date().getDay()]}} {{new Date().getDate()}}, {{monthNames[new Date().getMonth()]}} {{new Date().getFullYear()}} </p>
          <img class="block w-24 h-24" src="../../../assets/images/cloudy.png">
          <p class="font-bold text-2xl">{{temperatures.currently.summary}}</p>
        </div>
        <div class="text-right ml-auto">
          <div class="block">
            <h1 class="mb-base text-white font-bold text-8xl">{{filter === 'C' ? parseInt((temperatures.currently.temperature-32) * 5/9 ) : parseInt(temperatures.currently.temperature)}}&deg;</h1>
            <p class="text-3xl mb-base"> {{ filter === 'C' ? parseInt((temperatures.daily.data[0].temperatureHigh-32) * 5/9) : parseInt(temperatures.daily.data[0].temperatureHigh)}}&deg; / {{filter === 'C' ? parseInt((temperatures.daily.data[0].temperatureLow-32) * 5/9 ) : parseInt(temperatures.daily.data[0].temperatureLow)}}&deg;</p>
            <p class="text-lg font-semibold">{{temperatures.hourly.summary}}</p>
          </div>
        </div>
      </div>
      <vs-tabs class="w-3/4">
        <vs-tab label="Hourly">
          <hourly-temp :hourlyData="hourlyData" :filter="filter"></hourly-temp>
        </vs-tab>
        <vs-tab label="Daily">
          <daily-temp :dailyData="dailyData" :filter="filter"></daily-temp>
        </vs-tab>
      </vs-tabs>
    </div>
  </div>    
</template>

<script>
import HourlyTemp from './HourlyTemp.vue'
import DailyTemp from './DailyTemp.vue'
import AXIOS from '../../../http/axios/index.js'

export default {
  data () {
    return {
      monthNames: [
        'January', 'February', 'March', 'April', 'May', 'June', 
        'July', 'August', 'September', 'October', 'November', 'December'
      ],
      days: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      location: {
        lat: 0,
        lng: 0
      },
      degrees: ['C', 'F'],
      filter: 'F',
      temperatures: {
        currently: {
          summary: ''
        },
        hourly: {
          summary: ''
        },
        daily: {
          data: [
            {
              temperatureHigh: 0,
              temperatureLow: 0
            }
          ]
        }
      },
      dailyData: [],
      hourlyData: [],
      city: ''
    }
  },
  components: {
    HourlyTemp,
    DailyTemp
  },
  created () {
    this.$getLocation({})
      .then(coordinates => {
        this.location = coordinates
        this.loadTemperatures()
        this.loadCity()
      })
  },
  methods: {
    loadTemperatures () {
      this.$vs.loading()
      AXIOS.get(`/forecast/${process.env.VUE_APP_DARKSKY_API_KEY}/${this.location.lat},${this.location.lng}`)
        .then(response => {
          this.temperatures = response.data
          this.dailyData = response.data.daily
          this.hourlyData = response.data.hourly.data.slice(0, 24)
          this.$vs.loading.close()
        })
        .catch(() => {
          this.$vs.notify({
            color:'danger',
            title:'Failed',
            text:'Error. Please try again',
            position: 'top-center'
          })
          this.$vs.loading.close()
        })
    },
    customStyle (degree) {
      if (this.filter === degree) return 'box-shadow: 0 2px 8px 0 rgba(0,0,0,0.14) !important;'
    },
    loadCity () {
      this.$vs.loading()
      AXIOS.get(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${this.location.lat},${this.location.lng}&key=${process.env.VUE_APP_GOOGLE_MAPS_API_KEY}`)
        .then(response => {
          const cityName = response.data.plus_code.compound_code.split(' ')
          cityName.shift()
          this.city = cityName
          this.$vs.loading.close()
        })
        .catch(() => {
          this.$vs.notify({
            color:'danger',
            title:'Failed',
            text:'Error. Please try again',
            position: 'top-center'
          })
          this.$vs.loading.close()
        })
    }
  }
}
</script>
