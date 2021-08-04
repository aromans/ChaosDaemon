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

#define BUFFER_SIZE 500 // 500 bytes buffer
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
    void onDisconnect(void (*dc)(uint16_t fd));

    template <typename T>
    void onInput(void (*rc)(T fd, char *buffer)) {
        receiveCallback = rc;
    }


    uint16_t sendMessage(int sock_fd, const char* messageBuffer);
    uint16_t sendMessage(int sock_fd, char* messageBuffer);
    uint16_t sendMessage(Connector conn, const char* messageBuffer);
    uint16_t sendMessage(Connector conn, char* messageBuffer);
public:
    int isactive;

    std::map<int, std::string> connectedclients;

private:
    fd_set serverfds;
    fd_set tempfds;

    uint16_t maxfd;
    
    std::map<std::string, int> client_ids;

    int serversocket_fd;
    int tempsocket_fd;

    // struct sockaddr_storage client_addr;
    struct sockaddr_in servaddr, client_addr;

    char input_buffer[BUFFER_SIZE];

    char remote_ip[INET6_ADDRSTRLEN];

    void (*newConnectionCallback) (uint16_t fd);
    void (*receiveCallback) (const char* fd, char *buffer);
    void (*disconnectCallback) (uint16_t fd);

    //function prototypes
    void setup(int port);
    void initializeSocket();
    void bindSocket();
    void startListen();
    void handleNewConnection();
    void recvInputFromExisting(int fd);

    //message handler methods
    void readXBytes(int socket, uint32_t x, void* buffer);
    void DisectHeader(int fd, std::string header);
};

#endif // SERVER_HPP