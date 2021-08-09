/*
* daemonize.c
* This example daemonizes a process, writes a few log messages,
* sleeps 20 seconds and terminates afterwards.
* This is an answer to the stackoverflow question:
* https://stackoverflow.com/questions/17954432/creating-a-daemon-in-linux/17955149#17955149
* Fork this code: https://github.com/pasce/daemon-skeleton-linux-c
* Read about it: https://nullraum.net/how-to-create-a-daemon-in-c/
*/
    
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

#define MAX 80
#define PORT 3000
#define SA struct sockaddr

static void skeleton_daemon()
{
    pid_t pid;
    
    /* Fork off the parent process */
    pid = fork();
    
    /* An error occurred */
    if (pid < 0)
        exit(EXIT_FAILURE);
    
     /* Success: Let the parent terminate */
    if (pid > 0)
        exit(EXIT_SUCCESS);
    
    /* On success: The child process becomes session leader */
    if (setsid() < 0)
        exit(EXIT_FAILURE);
    
    /* Catch, ignore and handle signals */
    /*TODO: Implement a working signal handler */
    signal(SIGCHLD, SIG_IGN);
    signal(SIGHUP, SIG_IGN);
    
    /* Fork off for the second time*/
    pid = fork();
    
    /* An error occurred */
    if (pid < 0)
        exit(EXIT_FAILURE);
    
    /* Success: Let the parent terminate */
    if (pid > 0)
        exit(EXIT_SUCCESS);
    
    /* Set new file permissions */
    umask(0);
    
    /* Change the working directory to the root directory */
    /* or another appropriated directory */
    chdir("/");
    
    /* Close all open file descriptors */
    int x;
    for (x = sysconf(_SC_OPEN_MAX); x>=0; x--)
    {
        close (x);
    }
    
    /* Open the log file */
    openlog ("ch@os", LOG_PID, LOG_DAEMON);
}

int main()
{
    skeleton_daemon();

    // char connectionRequest[1024];
    char connectionRequest[100];
    strcpy(connectionRequest, "ClientID: Chaos Request: Connection ");
    // snprintf(connectionRequest, 10, "", strlen(connectionHeader));
    // strcat(connectionRequest, connectionHeader);    

    int sockfd, connfd;
    struct sockaddr_in servaddr, cli;
  
    // socket create and varification
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        syslog(LOG_NOTICE, "socket creation failed...\n");
        close(sockfd);
        exit(0);
    }
    else
        syslog(LOG_NOTICE, "Socket successfully created..\n");
    bzero(&servaddr, sizeof(servaddr));
  
    // assign IP, PORT
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    servaddr.sin_port = htons(PORT);

    // connect the client socket to server socket
    if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr)) != 0) {
        syslog(LOG_NOTICE, "connection with the server failed...\n");
        close(sockfd);
        exit(0);
    }
    else {
        syslog(LOG_NOTICE, "connected to the server..\n");
        write(sockfd, connectionRequest, sizeof(connectionRequest));
    }
    
    syslog (LOG_NOTICE, "First daemon started.");

    ssize_t n;
    char buff[1024];

    while (1)
    {
        sleep (1);

        n = recv(sockfd, buff, 1024, 0);

        if (buff != NULL && buff != "") {
            syslog (LOG_NOTICE, "The command sent from front end: '%s'", buff);
            bzero(buff, sizeof(buff));
        }

        if (n < 0) {
            syslog (LOG_NOTICE, "n < 0, exiting Daemon!");
            break;
        }
    }
   
    syslog (LOG_NOTICE, "First daemon terminated.");
    closelog();

    // close the socket
    close(sockfd);
    
    return EXIT_SUCCESS;
}
