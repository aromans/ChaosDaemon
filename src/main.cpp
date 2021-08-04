#include <iostream>
#include <cstdint>
#include <vector>
#include <string>

#include "server.hpp"

Server server;

void handleServerConnection(uint16_t fd) {
    std::cout << "Got connection from " << fd << std::endl;
}

void handleServerDisconnect(uint16_t fd) {
    std::cout << "Got disconnect from " << server.connectedclients[fd] << std::endl;
}

template <typename T>
void handleServerInput(T fd, char* buffer) {
    std::cout << "Got input '" << buffer << "' from " << fd << std::endl;
}


int main(int argc, char** argv) {
    server.onConnect(handleServerConnection);
    server.onDisconnect(handleServerDisconnect);
    server.onInput(handleServerInput<const char*>);
    server.init();

    while(server.isactive) {
        server.loop();
    }
}