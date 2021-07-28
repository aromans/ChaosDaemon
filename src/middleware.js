const io = require("socket.io-client");

const socket = io("http://localhost:11000");

socket.on("connect", () => {
  socket.emit("greetings", "Hello Server!");
})

socket.on("message", () => {
  console.log("PINGED FROM SERVER!");
});

socket.on("hi", (data) => {
  console.log(data);
});