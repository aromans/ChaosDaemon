#ifndef SERVER_HPP
#define SERVER_HPP

/* https://github.com/Gydo194/server */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h> //sockaddr, socklen_t
#include <arpa/inet.h>
#include <netdb.h>
#include <iostream>
#include <map>
#include <string>
#include <list>

#define BUFFER_SIZE 500 // 100 bytes buffer
#define MAX_CLIENTS 5
#define DEFAULT_PORT 3000

class Server 
{
public:
    Server();
    Server(int port);

    virtual ~Server();
    
    struct Connector {
        uint16_t source_fd;
    };
    
    void shutdown();
    void init();
    void loop();

    //callback setters
    void onConnect(void (*ncc)(uint16_t fd));
    void onInput(void (*rc)(uint16_t fd, char *buffer));
    void onDisconnect(void (*dc)(uint16_t fd));

    uint16_t sendMessage(Connector conn, const char* messageBuffer);
    uint16_t sendMessage(Connector conn, char* messageBuffer);
public:
    int isactive;

private:
    fd_set serverfds;
    fd_set tempfds;

    uint16_t maxfd;

    std::map<std::string, int> connectedclients;
    std::string                client_names[5];

    int serversocket_fd;
    int tempsocket_fd;

    // struct sockaddr_storage client_addr;
    struct sockaddr_in servaddr, client_addr;

    char input_buffer[BUFFER_SIZE];

    char remote_ip[INET6_ADDRSTRLEN];

    void (*newConnectionCallback) (uint16_t fd);
    void (*receiveCallback) (uint16_t fd, char *buffer);
    void (*disconnectCallback) (uint16_t fd);

    //function prototypes
    void setup(int port);
    void initializeSocket();
    void bindSocket();
    void startListen();
    void handleNewConnection();
    void recvInputFromExisting(int fd);
};

#endif // SERVER_HPP