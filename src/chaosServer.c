#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#define MAX 80
#define PORT 11000
#define SA struct sockaddr

// Function designed for chat between client and server.
void func(int sockfd)
{
    char buff[MAX];
    int n;
    // infinite loop for chat
    for (;;) {
        bzero(buff, MAX);
  
        // read the message from client and copy it in buffer
        read(sockfd, buff, sizeof(buff));
        // print buffer which contains the client contents
        printf("From client: %s", buff);
        bzero(buff, MAX);

        strcpy(buff, "Copy that!\n");
  
        // and send that buffer to client
        write(sockfd, buff, sizeof(buff));
  
        // if msg contains "Exit" then server exit and chat ended.
        if (strncmp("exit", buff, 4) == 0) {
            printf("Server Exit...\n");
            break;
        }
    }
}

void report(const char* msg, int terminate) {
  perror(msg);
  if (terminate) exit(-1); /* failure */
}
  
// Driver function
int main()
{
  int fd = socket(AF_INET,     /* network versus AF_LOCAL */
                  SOCK_STREAM, /* reliable, bidirectional, arbitrary payload size */
                  0);          /* system picks underlying protocol (TCP) */
  if (fd < 0) report("socket", 1); /* terminate */

  /* bind the server's local address in memory */
  struct sockaddr_in saddr;
  memset(&saddr, 0, sizeof(saddr));          /* clear the bytes */
  saddr.sin_family = AF_INET;                /* versus AF_LOCAL */
  saddr.sin_addr.s_addr = htonl(INADDR_ANY); /* host-to-network endian */
  saddr.sin_port = htons(11000);        /* for listening */

  if (bind(fd, (struct sockaddr *) &saddr, sizeof(saddr)) < 0)
    report("bind", 1); /* terminate */

  /* listen to the socket */
  if (listen(fd, 2) < 0) /* listen for clients, up to MaxConnects */
    report("listen", 1); /* terminate */

  fprintf(stderr, "Listening on port %i for clients...\n", 11000);
  /* a server traditionally listens indefinitely */
  while (1) {
    struct sockaddr_in caddr; /* client address */
    int len = sizeof(caddr);  /* address length could change */

    int client_fd = accept(fd, (struct sockaddr*) &caddr, &len);  /* accept blocks */
    if (client_fd < 0) {
      report("accept", 0); /* don't terminate, though there's a problem */
      continue;
    }

    /* read from client */
    int i;
    for (i = 0; i < 1000; i++) {
      char buffer[1024 + 1];
      memset(buffer, '\0', sizeof(buffer));
      int count = read(client_fd, buffer, sizeof(buffer));
      if (count > 0) {
        puts(buffer);
        write(client_fd, buffer, sizeof(buffer)); /* echo as confirmation */
      }
    }
    close(client_fd); /* break connection */
  }  /* while(1) */
  return 0;
}