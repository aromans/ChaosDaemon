const io = require("socket.io")(11000);

io.on("connection", socket => {
    socket.send("Hello Client!")

    socket.on("message", (data) => {
        console.log(data);
    });
    
    socket.on("greetings", (data) => {
        console.log(data);
    });

    io.of("/").emit("hi", "everyone");
});
