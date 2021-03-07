<template>
  <div class="py-10">
    <div class="overflow-x-auto vs-row">
      <div class="vs-col flex">
        <div class="text-center mr-10 w-full mb-base" v-for="(item,index) in hourlyData" :key="index">
          <p>{{index === 0 ? 'Now' : hours[index]+ ':00'}}</p>
          <img class="w-16 h-16" :src="hours[index] === 12 ? sunnyImage : cloudyImage">
          <p class="w-full text-2xl">{{filter === 'C' ?parseInt((item.temperature-32) * 5/9 ) : parseInt(item.temperature)}}  &deg;</p>
        </div>
      </div> 
    </div>
  </div>
</template>

<script>
import cloudyImage from '../../../assets/images/cloudy.png'
import sunnyImage from '../../../assets/images/sunny.png'

export default {
  props:['hourlyData', 'filter'],
  data () {
    return {
      hour: '',
      hours: [],
      cloudyImage,
      sunnyImage
    }
  },
  created () {
    this.hour = new Date().getHours()
    this.hours = []
    for (let i = this.hour; this.hours.length <= 25; i++) {
      if (i === 24) {
        i = 0
      }
      if (i <= 9) {
        i = `0${i}`
      }
      this.hours.push(i)
    }
  }
}

</script>
