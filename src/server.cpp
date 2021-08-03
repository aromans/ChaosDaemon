#pragma region Include/Imports
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <syslog.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/time.h>
#include <errno.h> 

#include <iostream>
#include <map>
#include <string>
#include <list>

typedef char Int8;
typedef short int Int16;
typedef int Int32;

typedef unsigned char UInt8;
typedef unsigned short int UInt16;
typedef unsigned int UInt32;
#define SA struct sockaddr

const std::string NOT_A_STRING = "";
#pragma endregion

#pragma region Utility Methods
// This assumes buffer is at least x bytes long,
// and that the socket is blocking.
void ReadXBytes(int socket, unsigned int x, void* buffer)
{
    int bytesRead = 0;
    int result;
    while (bytesRead < x)
    {
        result = read(socket, buffer, x - bytesRead);
        if (result < 1)
        {
            continue;
        }

        bytesRead += result;

        printf("Received value: %s\n", (char*)buffer);
    }
}

std::map<std::string, std::string> DisectHeader(std::string header) {
    std::map<std::string, std::string> header_values;
    std::string word = "";
    std::string prevWord = "";
    for (auto x = std::begin(header); x != std::end(header); ++x) 
    {
        if (*x != ' ') {
            word.push_back(*x);
        } else {
            if (prevWord != NOT_A_STRING) {
                if (prevWord == "ClientID:") {
                    header_values["ClientID"] = word;
                } else if (prevWord == "Request:") {
                    header_values["Request"] = word;
                } else {
                    fprintf(stderr, "No match for header key and value: %s - %s\n", prevWord.c_str(), word.c_str());
                }
                prevWord = "";
            } else {
                prevWord = word;
            }

            word = "";
        }

    }
    return header_values;
}
#pragma endregion

#pragma region Process Commands
// void process_commands(int sockfd, std::map<std::string, int>& clients) {
//   UInt16      length = 0;
//   char*       buffer = 0;
//   ssize_t     n;
//   char        command[1024];
//   int         messageLength;
//   again:
    
//     for (;;) {

//         ReadXBytes(sockfd, sizeof(length), (void*)(&length));
//         buffer = new char[length];

//         try {
//             messageLength = std::stoi(std::string((char*)(void*)(&length)));
//         } catch(std::exception e) {
//             printf("There was an error trying to process command length %s", (char*)(void*)(&length));
//             goto again;
//         }

//         ReadXBytes(sockfd, std::stoi(std::string((char*)(void*)(&length))), (void*)buffer);

//         auto header_values = DisectHeader(std::string(buffer));

//         if (header_values["ClientID"] == "Flutter") {
//             if (header_values["Request"] == "Command") {
//                 if (clients.find("Chaos") != clients.end()) {
//                     bzero(command, sizeof(command));
//                     n = read(sockfd, command, 1024);
//                     write(clients["Chaos"], command, n); 
//                     bzero(command, sizeof(command));

//                     if (n < 0) {
//                         break;
//                     }
//                 } else {
//                     fprintf(stderr, "The following client '%s' does not exist!\n", "Chaos");
//                 }
//             } else if (header_values["Request"] == "Exit") {
//                 printf("Exiting");
//                 break;
//             }
//         }
  

//         // bzero(buf, sizeof(buf));
//         // n = read(sockfd, buf, 1024);
//         // printf("%s\n", buf);
//         // write(sockfd, buf, n);
//         // bzero(buf, sizeof(buf));

//         // if (n < 0) {
//         //   break;
//         // }
//     }
// };
#pragma endregion

int main(int argc, char **argv) {
    int                 listenfd, connfd, max_sd, sd, client_socket[5];
    std::string         client_names[5];
    int                 opt = 1;  
    pid_t               childpid;
    socklen_t           clilen;
    struct sockaddr_in  cliaddr, servaddr;
    UInt16              length = 0;
    char*               buffer = 0;
    std::map<std::string, int> connectedclients;

    std::string greeting = "You are connected to Chaos Daemon v1.0 \r\n"; 

    //set of socket descriptors 
    fd_set readfds;

    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    
    if( setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, (char *)&opt, 
          sizeof(opt)) < 0 )  
    {  
        perror("setsockopt");  
        exit(EXIT_FAILURE);  
    }  

    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family      = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port        = htons(3000);

    bind(listenfd, (SA*) &servaddr, sizeof(servaddr));

    listen(listenfd, 5);

    clilen = sizeof(cliaddr);

    for ( ; ; ) {

        //clear the socket set 
        FD_ZERO(&readfds);  
     
        //add master socket to set 
        FD_SET(listenfd, &readfds);  
        max_sd = listenfd; 

        // adding child sockets
        for (int i = 0; i < 5; ++i)  
        {  
            //socket descriptor 
            sd = client_socket[i];  
                 
            //if valid socket descriptor then add to read list 
            if(sd > 0)  
                FD_SET( sd , &readfds);  
                 
            //highest file descriptor number, need it for the select function 
            if(sd > max_sd)  
                max_sd = sd;  
        } 

        int activity = select( max_sd + 1 , &readfds , NULL , NULL , NULL); 

        if ((activity < 0) && (errno != EINTR)) {
            fprintf(stderr, "Selection Error!");
        }

        if (FD_ISSET(listenfd, &readfds)) {
            connfd = accept(listenfd, (SA *) &cliaddr, &clilen);

            //inform user of socket number - used in send and receive commands 
            printf("New connection , socket fd is %d , ip is : %s , port : %d\n", 
                connfd , inet_ntoa(cliaddr.sin_addr) , ntohs
                (cliaddr.sin_port));

            /* Read the number of bytes in the header */
            ReadXBytes(connfd, sizeof(length), (void*)(&length));

            /* Read the Header of size Length in bytes */
            printf("The length is %d\n", std::stoi(std::string((char*)(void*)(&length))));
            buffer = new char[length];
            ReadXBytes(connfd, std::stoi(std::string((char*)(void*)(&length))), (void*)buffer);

            /* Process the Header request */
            auto header_values = DisectHeader(std::string(buffer));

            printf("ClientID '%s' connected!\n", header_values["ClientID"].c_str());
            std::string clientid = header_values["ClientID"];

            // if (clientid == "Chaos") {
            //     printf("Does flutter still exist? %d\n", connectedclients["Flutter"]);
            // }

            if (send(connfd, greeting.c_str(), strlen(greeting.c_str()), 0) != strlen(greeting.c_str())) {
                perror("Send Error");
            }

            puts("Welcome message sent successfully!");

            //add new socket to array of sockets 
            for (int i = 0; i < 5; i++)  
            {  
                //if position is empty 
                if( client_socket[i] == 0 )  
                {  
                    // connectedclients[clientid] = i;
                    // client_names->append(clientid);
                    client_socket[i] = connfd;  
                    printf("Adding to list of sockets as %d\n" , i);  
                         
                    break;  
                }  
            }  
        }

        for (int i = 0; i < 5; ++i) {
            // std::string name = client_names[i];
            sd = client_socket[i];//connectedclients[name]];
            int result;
            char incoming[1024];

            bzero(incoming, sizeof(incoming));

            if (FD_ISSET(sd, &readfds)) {
                if ((result = read(sd, incoming, 1024)) == 0) {
                    // getpeername(sd, (SA*)&cliaddr, (socklen_t*)&clilen);

                    // printf("Host disconnected , ip %s , port %d \n" ,
                    //       inet_ntoa(cliaddr.sin_addr) , ntohs(cliaddr.sin_port));

                    close(sd);
                    client_socket[i] = 0;
                    // client_names[i] = "\0";
                    // connectedclients.erase(name);
                } else {

                }
            }
        }


        // if ( (childpid = fork()) == 0) {    /* child process */
        //     printf("Connecting a client now . . . \n");
        //     close(listenfd);    /* close listening socket */

        //     /* Read the number of bytes in the header */
        //     ReadXBytes(connfd, sizeof(length), (void*)(&length));

        //     /* Read the Header of size Length in bytes */
        //     printf("The length is %d\n", std::stoi(std::string((char*)(void*)(&length))));
        //     buffer = new char[length];
        //     ReadXBytes(connfd, std::stoi(std::string((char*)(void*)(&length))), (void*)buffer);

        //     /* Process the Header request */
        //     auto header_values = DisectHeader(std::string(buffer));

        //     printf("ClientID '%s' connected!\n", header_values["ClientID"].c_str());
        //     std::string clientid = header_values["ClientID"];
        //     connectedclients[clientid] = connfd;

        //     if (clientid == "Chaos") {
        //         printf("Does flutter still exist? %d\n", connectedclients["Flutter"]);
        //     }

        //     process_commands(connfd, connectedclients);   /* Process the daemon command */
        //     exit(0);
        // }

        // close(connfd);          /* parent closes connected socket */
    }

    delete [] buffer;

    FD_CLR(listenfd, &readfds);

    close(listenfd);
}