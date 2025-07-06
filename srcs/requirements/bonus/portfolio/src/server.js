const express = require("express");
const path = require("path");

const app = express();
const port = 3000;

app.use(express.static(path.join(__dirname, "public")));

app.get("/status", (req, res) => {
  res.sendStatus(200);
});

app.listen(port, () => {
  console.log(`Portfolio app listening on port ${port}`);
});
