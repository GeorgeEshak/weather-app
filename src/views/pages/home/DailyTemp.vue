<template>
  <div class="py-10">
    <div class="overflow-x-auto vs-row">
      <div class="vs-col flex">
        <div class="text-center mr-10 w-full mb-base" v-for="(item,index) in dailyData.data" :key="index">
          <p>{{daysSorted[index]}}</p>
          <img class="w-16 h-16" src="../../../assets/images/cloudy.png">
          <p class="w-full text-2xl">{{filter === 'C' ?parseInt((item.temperatureHigh-32) * 5/9 ) : parseInt(item.temperatureHigh)}}  &deg;</p>
        </div>
      </div> 
    </div>
  </div>
</template>

<script>
export default {
  props: ['dailyData', 'filter'], 
  data () {
    return {
      days: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      daysSorted: [],
      today: ''
    }
  },
  mounted () {
    this.today = this.days[new Date().getDay()]
    const goBackDays = 7
    const today = new Date()
    this.daysSorted.push(this.today)
    for (let i = 0; i < goBackDays; i++) {
      const newDate = new Date(today.setDate(today.getDate() + 1))
      this.daysSorted.push(this.days[newDate.getDay()])
    }
  }
}
</script>
