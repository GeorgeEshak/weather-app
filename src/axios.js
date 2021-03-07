import axios from 'axios'

export default axios.create({
  baseURL: `https://cors-anywhere.herokuapp.com/${process.env.VUE_APP_API_URL}`
})
