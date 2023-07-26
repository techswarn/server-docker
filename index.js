const keys = require("./keys");

const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const redis = require("redis");
const app = express();
const weather = require("./weather");
app.use(cors());
app.use(bodyParser.json());

const { Pool } = require("pg");
const { parse } = require("pg-protocol");
const pgClient = new Pool({
  user: keys.pgUser,
  host: keys.pgHost,
  database: keys.pgDatabase,
  password: keys.pgPassword,
  port: keys.pgPort,
});

pgClient.on("connect", (client) => {
  client
    .query("CREATE TABLE IF NOT EXISTS values (number INT)")
    .catch((err) => console.error(err));
});

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000,
});

const redisPublisher = redisClient.duplicate();

app.get("/", (req, res) => {
  res.send("hello from server v5");
});

app.get("/api/v1/weather", async (req, res) => {
  const data = await weather.getWeather();
  console.log(data);

  res.json({ data: data });
});

app.get("/values/all", async (req, res) => {
  const values = await pgClient.query("SELECT * FROM values");
  res.send(values.rows);
});

app.get("/values/current", async (req, res) => {
  redisClient.hgetall("values", (err, values) => {
    res.send(values);
  });
});

app.post("/values", async (req, res) => {
  const index = req.body.index;
  if (parseInt(index) > 40) {
    return res.status(422).send("index too high");
  }

  redisClient.hset("values", index, "nothing yet!");
  redisPublisher.publish("insert", index);
  pgClient.query("INSERT INTO values(number) VALUES($1)", [index]);

  res.send({ working: true });
});

app.listen(8000, (err) => {
  console.log("listen on port 8000");
});
