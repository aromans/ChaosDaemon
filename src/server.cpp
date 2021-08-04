#include "server.hpp"

Server::Server() {
    setup(DEFAULT_PORT);
}

Server::Server(int port) {
    setup(port);
}

Server::~Server() {
    std::cout << "Destroying Server... \n";
    close(serversocket_fd);
}

void Server::setup(int port) {
    serversocket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (serversocket_fd < 0) {
        perror("Server Socket Creation Failed!");
    }

    FD_ZERO(&serverfds); //Initializes the file descriptor set fdset to have zero bits for all file descriptors. 
    FD_ZERO(&tempfds);

    memset(&servaddr, 0, sizeof(servaddr)); //bzero
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htons(INADDR_ANY);
    servaddr.sin_port = htons(port);

    bzero(input_buffer, BUFFER_SIZE);
}

void Server::initializeSocket() {
    std::cout << "Initializing server socket\n";

    int opt_value = 1;
    int ret = setsockopt(serversocket_fd, SOL_SOCKET, SO_REUSEADDR, (char*)&opt_value, sizeof(int));

    printf("Server setsockopt() ret %d\n", ret);

    if (ret < 0) {
        perror("Server error: setsockopt() failed");
        shutdown();
    }
}

void Server::bindSocket() { 
    std::cout << "Binding server socket\n";

    int ret = bind(serversocket_fd, (struct sockaddr *)&servaddr, sizeof(servaddr));

    if (ret < 0) {
        perror("Server error: bind() failed");
    }

    FD_SET(serversocket_fd, &serverfds); //Sets the bit for the file descriptor fd in the file descriptor set fdset. 
    maxfd = serversocket_fd; // set the current known maximum file descriptor count
}

void Server::startListen() { 
    std::cout << "Server starting to listen for clients... \n";

    int ret = listen(serversocket_fd, MAX_CLIENTS);

    printf("Server listen() ret %d\n", ret);

    if (ret < 0) {
        perror("Server error: listen() failed");
    }
}

void Server::shutdown() {
    int ret = close(serversocket_fd);
    isactive = 0;
    printf("Server shutdown closing serversocketfd.. ret '%d'.\n", ret);
}

void Server::handleNewConnection() {
    std::cout << "Server handling a new connection\n";

    socklen_t addrlen = sizeof(client_addr);
    tempsocket_fd = accept(serversocket_fd, (struct sockaddr *)&client_addr, &addrlen);

    if (tempsocket_fd < 0) {
        perror("Server error: accept() failed");
    } else {
        FD_SET(tempsocket_fd, &serverfds);
        // increment the maximum known file descriptor (select() needs it)
        if (tempsocket_fd > maxfd) {
            maxfd = tempsocket_fd;
            std::cout << "Server incrementing maxfd to " << maxfd << std::endl;
        }
        printf("New connection , socket fd is %d , ip is : %s , port : %d\n", 
            tempsocket_fd, 
            inet_ntoa(client_addr.sin_addr), 
            ntohs(client_addr.sin_port));
    }
    newConnectionCallback(tempsocket_fd);
 }

void Server::recvInputFromExisting(int fd) {
    int bytesrecv = recv(fd, input_buffer, BUFFER_SIZE, 0);
    if (bytesrecv <= 0) {
        if (0 == bytesrecv) {
            disconnectCallback((uint16_t)fd);
        } else {
            perror("Server error: recv() failed");
        }
        close(fd);
        FD_CLR(fd, &serverfds); //Clears the bit for the file descriptor fd in the file descriptor set fdset.
        return;
    }

    printf("Server Received '%s' from client!\n", input_buffer);

    if (connectedclients.find(fd) != connectedclients.end()) {
        if (client_ids["Flutter"] == fd) {
            this->sendMessage(client_ids["Chaos"], input_buffer);
        }

        receiveCallback(connectedclients[fd].c_str(), input_buffer);
    } else {
        DisectHeader(fd, input_buffer);

        if (connectedclients.find(fd) != connectedclients.end()) {
            receiveCallback(connectedclients[fd].c_str(), input_buffer);
        } else {
            perror("Server error: a client id wasn't fully recorded!");
        }
    }

    bzero(&input_buffer, BUFFER_SIZE);
 }

 void Server::loop() {
    tempfds = serverfds;
    std::cout << "Server calling select()\n";

    /*Indicates which of the specified file descriptors
    is ready for reading, ready for writing, 
    or has an error condition pending. */
    int sel = select(maxfd + 1, &tempfds, NULL, NULL, NULL); // blocks until activity

    if (sel < 0) {
        perror("Server error: select() failed");
        shutdown();
    }

    for (int i = 0; i <= maxfd; i++) {
        if (FD_ISSET(i, &tempfds)) { //Returns a non-zero value if the bit for the file descriptor fd is set in the file descriptor set pointed to by fdset, and 0 otherwise.
            if (serversocket_fd == i) {
                // new connection on master socket
                handleNewConnection();
            } else {
                //existing connection has new data
                recvInputFromExisting(i);
            }
        }
    }
 }

void Server::init() {
    initializeSocket();
    bindSocket();
    startListen();
    isactive = 1;
}


void Server::readXBytes(int socket, unsigned int x, void* buffer) {
    int bytesRead = 0;
    int result;
}

void Server::DisectHeader(int fd, std::string header) {
    std::map<std::string, std::string> header_values;
    std::string word = "";
    std::string prevWord = "";
    for (auto x = std::begin(header); x != std::end(header); ++x) 
    {
        if (*x != ' ') {
            word.push_back(*x);
        } else {
            if (prevWord != "") {
                if (prevWord == "ClientID:") {
                    header_values["ClientID"] = word;
                } else if (prevWord == "Request:") {
                    header_values["Request"] = word;
                }
                prevWord = "";
            } else {
                prevWord = word;
            }

            word = "";
        }
    }

    if (header_values["Request"] == "Connection" ||
        header_values["Request"] == "Connection\r\n\r\n") {
        connectedclients[fd] = header_values["ClientID"];
        client_ids[header_values["ClientID"]] = fd;
    }
}

void Server::onConnect(void (*ncc)(uint16_t)) {
    newConnectionCallback = ncc;
}

void Server::onDisconnect(void (*dc)(uint16_t)) {
    disconnectCallback = dc;
}

uint16_t Server::sendMessage(int sock_fd, const char* messageBuffer) {
    return send(sock_fd, messageBuffer, strlen(messageBuffer), 0);
}

uint16_t Server::sendMessage(int sock_fd, char* messageBuffer) {
    return send(sock_fd, messageBuffer, strlen(messageBuffer), 0);
}

uint16_t Server::sendMessage(Connector conn, const char* messageBuffer) {
    return send(conn.source_fd, messageBuffer, strlen(messageBuffer), 0);
}

uint16_t Server::sendMessage(Connector conn, char* messageBuffer) {
    return send(conn.source_fd, messageBuffer, strlen(messageBuffer), 0);
}   