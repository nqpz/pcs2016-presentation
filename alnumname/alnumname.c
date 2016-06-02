/* Uber Awesome welcome screen
 * Copyright (C) 1995 Karl Koder
 * All rights reserved */

#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

static char request[1024]; /* TODO: Do we still need this? */

/* Make sure it's large enough for the future */
static char parsedvalue[65536];
int get_value(char* keyname, char* req);

int name_error()
{
    printf("Content-Type: text/html\n\n");
    printf("Invalid name, please don't use any special characters.");
    return 1;
}

int handle_post(char* postdata)
{
    int len;
    char name[100] = {0}; /* No one has longer names than that*/
    if (!(len = get_value("name", postdata)))
        return name_error();
    memcpy(name, parsedvalue, len); 

    printf("Content-Type: text/html\n\n");
    printf("<BODY BACKGROUND=../bg.jpg><H1><FONT><BLINK>WELCOME %s</H1></BLINK>", name);
}

/* The magic sauce! */
int get_value(char* keyname, char* req)
{
    char* key;
    char* buf = parsedvalue;
    char* value = 0;
    while (*req)
    {
        for (key = req; *req && *req != '&'; req++)
        {
            if (*req == '=' && strncmp(key, keyname, strlen(keyname)) == 0)
            {
                value = req+1;
                goto outer;
            }
        }
    }
outer:
    if (!value)
        return 0;
    for (; *value && *value != '&'; value++, buf++)
    {
        if ((*value < 'a' || *value > 'z') && (*value < 'A' || *value > 'Z') &&
            (*value < '0' || *value > '9'))
        {
            return 0;
        }
        *buf = *value;
    }
    return buf - &parsedvalue[0];
}

int main(int argc, char* argv[])
{
    char* request_method = getenv("REQUEST_METHOD");
    if (strcmp(request_method, "POST") == 0)
    {
        char postdata[1024];
        int len = read(STDIN_FILENO, postdata, 1023);
        postdata[len] = 0;
        /*printf("postdata:%s\n", postdata);*/
        return handle_post(postdata);
    }

    printf("Content-Type: text/html\n\n");
    printf("<HTML><HEAD><TITLE>Totally Secure Form</TITLE>");
    printf("<BODY BACKGROUND=../bg.jpg><FORM ACTION=alnumname METHOD=POST>");
    printf("Enter nick: <INPUT TYPE=TEXT NAME=name><br>");
    printf("<INPUT TYPE=SUBMIT VALUE=OK>");
    printf("<HR>");
    printf("<SMALL>Copyright (C) 1995 Karl Koder");
}


