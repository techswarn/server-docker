const axios = require('axios');
const keys = require("./keys")
console.log(keys.apiKey)
const baseUrl = "https://api.openweathermap.org/data/2.5/weather";

const getWeather = async (city) => {
    console.log("-----1-----")
    try {
       const res = await axios.post(`${baseUrl}?lat=12.9141&lon=74.8560&appid=${keys.apiKey}`);
       const tempCel = res?.data?.main?.temp - 273.15
       console.log(`Temperature in mangalore is ${tempCel} c`)
       return tempCel;
    } catch(err) {
        console.log(err)
    }
}

module.exports = {getWeather}