/* Uber Awesome welcome screen
 * Copyright (C) 1995 Karl Koder
 * All rights reserved */

#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int name_error()
{
    printf("Content-Type: text/html\n\n");
    printf("Invalid name, please don't use any special characters.");
    return 1;
}

/* Make sure it's large enough for the future */
static char postdata[1048576];

int get_name(char* keyname, char* req, char* buf)
{
    char* key;
    char* name = 0;
    while (*req)
    {
        for (key = req; *req && *req != '&'; req++)
        {
            if (*req == '=' && strncmp(key, keyname, strlen(keyname)) == 0)
            {
                name = req+1;
                break;
            }
        }
    }
    if (!name)
        return 0;
    for (; *name && *name != '&'; name++, buf++)
    {
        if ((*name < 'a' || *name > 'z') && (*name < 'A' || *name > 'Z') &&
            (*name < '0' || *name > '9'))
        {
            return 0;
        }
        *buf = *name;
    }
    return 1;
}

int handle_post()
{
    char name[50] = {0}; /* No one has longer names than that*/
    if (!get_name("name", postdata, name))
        return name_error();

    printf("Content-Type: text/html\n\n");
    printf("<H1><BLINK>WELCOME %s</H1></BLINK>", name);
}

int main(int argc, char* argv[])
{
    char* request_method = getenv("REQUEST_METHOD");
    if (strcmp(request_method, "POST") == 0)
    {
        int len = read(STDIN_FILENO, postdata, 1048575);
        return handle_post();
    }

    printf("Content-Type: text/html\n\n");
    printf("<HTML><HEAD><TITLE>Totally Secure Form</TITLE>");
    printf("<BODY><FORM ACTION=alnumname METHOD=POST>");
    printf("Enter nick: <INPUT TYPE=TEXT NAME=name><br>");
    printf("<INPUT TYPE=SUBMIT VALUE=OK>");
}

