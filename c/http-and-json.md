# HTTP and JSON with C

If we want to interact with a REST web API in C, or any other API that requires
the use of HTTP methods, then we'll need to find a way to work with HTTP and
JSON data.  

Working with HTTP/JSON in C can either be really difficult or really easy,
depending on how you go about doing it. It can be done manually with sockets
and a custom JSON parser, or we can use pre-existing libraries that were
created for this specific purpose.    


## Popular Libraries

There are a few popular libraries that are used to work with HTTP and JSON in C.  

For HTTP:

- `libcurl`: The "standard" C lib for handling HTTP request.  

For JSON:

- `cJSON`: A popular library for working with JSON data.  
    - <https://www.geeksforgeeks.org/c/cjson-json-file-write-read-modify-in-c/>
- `Jansson`: Feature-rich lib with a simple API.   
    - <https://github.com/akheron/jansson>
- `jsmn`: Super lighweight and portable, ideal for smaller systems or embedded systems.  
    - <https://zserge.com/jsmn/>
    - <https://github.com/zserge/jsmn>
- `yyjson`: A high performance JHSON library written in ANSI C, ideal for 
  performance-critical applications.    
    - <https://github.com/ibireme/yyjson>
- `json-c`: Another popular option with a straightforward API.  
    - Examples: <https://gist.github.com/alan-mushi/19546a0e2c6bd4e059fd>


## Example: Libcurl + cJSON for HTTP Request

A simple example of using libcurl and cJSON to make an HTTP request:
```c
#include <stdio.h>   /* printf, sprintf */
#include <stdlib.h>  /* memory management */
#include <string.h>  /* memory management */
#include <curl/curl.h>  /* functions to make HTTP requests */
#include "cJSON.h"   /* function for working with json */

/* #1 */
struct Memory {
    char *response;
    size_t size;
}

/* #2 */
static size_t write_callback(void *contents, size_t size, size_t nmemb, void *userp) {
   size_t total = size * nmemb;
   struct Mrmory *mem = (struct Mrmory *)userp;
   char *ptr = realloc(mem->response, mem->size + total + 1);
   if (!ptr) { return 0; }
   mem->response = ptr;
   memcpy(&(mem->response[mem->size]), contents, total);
   mem->size += total;
   mem->response[mem->size] = 0;
   return total;
}

int main() {
    CURL *curl = NULL;
    CURLcode res;
    struct Memory chunk = { NULL, 0 };

    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "https://example.comi/api");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&chunk);
        res = curl_easy_perform(curl);

        if (res == CURLE_OK) {
            printf("HTTP Response: %s\n", chunk.response);
            cJSON *json = cJSON_Parse(chunk.response);
            if(cJSON_IsString(title)) {
                printf("Extracted title: %s\n", title->valuestring);
            }
            cJSON_Delete(json);
        } else {
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }

        curl_easy_cleanup(curl);
        free(chunk.response);
    }
    curl_global_cleanup();
    return 0;
}
```

1. The `Memory` struct defines a memory buffer and its current size for the HTTP response.  
2. 

- Should be compiled with:
  ```bash
  gcc example.c -lcurl -lcjson -o example
  ```

- Replace the URL in the first `curl_easy_setopt()` function to match the API
  or data structure you need.  


