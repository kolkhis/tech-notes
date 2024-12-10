

# Go Project File Structure

Directories communicate how code should be used, whether it’s internal-only code, 
public libraries, configuration files, or executable commands.

Be explicit about your intentions by using the right directories!

For example, if some of your code isn't meant to be imported and used by other
people/applications, put it in the correct directory (`internal/`).  

## Table of Contents
* [Visualization](#visualization) 
* [Go Directories](#go-directories) 
    * [`/cmd`](#cmd) 
    * [`/internal`](#internal) 
    * [`/pkg`](#pkg) 
    * [`/vendor`](#vendor) 
* [Service Application Directories](#service-application-directories) 
    * [`/api`](#api) 
* [Web Application Directories](#web-application-directories) 
    * [`/web`](#web) 
* [Common Application Directories](#common-application-directories) 
    * [`/configs`](#configs) 
    * [`/init`](#init) 
    * [`/scripts`](#scripts) 
    * [`/build`](#build) 
    * [`/deployments`](#deployments) 
    * [`/test`](#test) 
* [Other Directories](#other-directories) 
    * [`/docs`](#docs) 
    * [`/tools`](#tools) 
    * [`/examples`](#examples) 
    * [`/third_party`](#thirdparty) 
    * [`/githooks`](#githooks) 
    * [`/assets`](#assets) 
    * [`/website`](#website) 
* [References](#references) 

## Visualization
Below is a visualization of all the directories you *can* have in your Go project.  

```bash
myproject/
├── cmd/
│   ├── myapp/
│   │   └── main.go
│   └── mycli/
│       └── main.go
├── internal/
│   ├── pkg1/
│   │   └── ...
│   └── pkg2/
│       └── ...
├── pkg/
│   └── mypackage/
│       └── ...
├── api/
│   └── api.go
├── web/
│   └── web.go
├── config/
│   └── config.yaml
├── scripts/
│   └── build.sh
├── tests/
│   └── ...
├── README.md
└── go.mod
```

* `cmd`: The `cmd` directory contains executable main packages
   for different applications or command-line utilities.  
    * Each subdirectory inside `cmd` represents an individual application or utility.  
    * For instance, you might have `myapp` for a web server and `mycli` for a command-line tool.

* `internal`: The `internal` directory contains private packages that should
   not be imported by external projects.  
    * This directory helps enforce encapsulation and avoids accidental use by external code.

* `pkg`: The `pkg` directory contains public packages that can be
   imported and used by external projects.  
    * It should contain reusable libraries and code that can be shared across 
      different parts of your project, or potentially across multiple projects.

* `api`: The `api` directory can contain code related to defining API contracts,
   such as gRPC or REST API definitions, if applicable.

* `web`: The `web` directory can contain web-related code.  
    * E.g., front-end assets or templates if your project includes a web application.

* `config`: The `config` directory can store configuration files.
    * E.g., `.yaml`, `.json`, or `.toml` files used by the application.
    
* `scripts`: The `scripts` directory can contain shell scripts for helper tasks.  
    * E.g., building, testing, or setting up the project.

* `tests`: The `tests` directory contains unit tests, integration tests, and
   other test-related files.

* `README.md`: A Markdown file with project documentation.
    * Should include instructions for building, testing, and running the project.

* `go.mod`: The `go.mod` file is used to manage Go dependencies for the project.


---


## Go Directories

These notes are taken directly from [golang-standards/project-layout](https://github.com/golang-standards/project-layout/blob/master/README.md?plain=1).  

### `/cmd`
Stores executable `main` packages that define entry points for the application or CLI tools.  

Each subdirectory inside `cmd/` corresponds to a separate executable program.  

```bash
myproject/
└── cmd/
    ├── myapp/
    │   └── main.go
    └── mycli/
        └── main.go
```
* `cmd/myapp/main.go`: Stores one application called `myapp`.  
* `cmd/mycli/main.go`: Stores a separate application called `mycli`.  

Keep the `main.go` files minimal. Let them just call functions from `internal/` or `pkg/`.  

Example `main.go`: 
```go
package main
 
import "myproject/internal/pkg1"
 
func main() {
    pkg1.Run()
}
```
It's common to have a small `main` function that imports and invokes the code from the 
`/internal` and `/pkg` directories and nothing else.

If the code is not reusable or if you don't want others to reuse it, put that code in 
the `/internal` directory.  

If you think the code can be imported and used in other projects, then it should live 
in the `/pkg` directory.  




### `/internal`
Contains code that is *not* intended for external use.  

The compiler enforces that packages in `internal/` cannot be imported by code outside
of the project.  



You are not limited to the top level `internal` directory,  
You can have more than one `internal` directory at any level of your project tree.

It's not required (especially for smaller projects), but it's nice to have visual clues 
showing the intended package use.  

Your actual application code can go in the `/internal/app` directory (e.g., `/internal/app/myapp`) and 
the code shared by those apps in the `/internal/pkg` directory (e.g., `/internal/pkg/myprivlib`).


### `/pkg`

Library code that's ok to use by external applications (e.g., `/pkg/mypubliclib`).  

Other projects will import these libraries expecting them to work, so think twice before 
you put something here :-) Note that the `internal` directory is a better way to ensure 
your private packages are not importable because it's enforced by Go.  

The `/pkg` directory is still a good way to explicitly communicate that the code in that 
directory is safe for use by others.  

The [`I'll take pkg over internal`](https://travisjeffery.com/b/2019/11/i-ll-take-pkg-over-internal/) blog 
post by Travis Jeffery provides a good overview of the `pkg` and `internal` directories 
and when it might make sense to use them.

It's also a way to group Go code in one place when your root directory contains lots of 
non-Go components and directories making it easier to run various Go tools (as mentioned 
in these talks: [`Best Practices for Industrial Programming`](https://www.youtube.com/watch?v=PTE4VJIdHPg) from 

GopherCon EU 2018, [GopherCon 2018: Kat Zien - How Do You Structure Your Go Apps](https://www.youtube.com/watch?v=oL6JBUk6tj0) and 
[GoLab 2018 - Massimiliano Pippi - Project layout patterns in Go](https://www.youtube.com/watch?v=3gQa1LWwuzk)).


This is a common layout pattern, but it's not universally accepted and some in the Go 
community don't recommend it.

It's ok not to use it if your app project is really small and where an extra level of 
nesting doesn't add much value (unless you really want to :-)).  

Think about it when it's getting big enough and your root directory gets pretty busy (especially 
if you have a lot of non-Go app components).

The `pkg` directory origins: The old Go source code used to use `pkg` for its packages 
and then various Go projects in the community started copying the pattern 
(see [`this`](https://twitter.com/bradfitz/status/1039512487538970624) Brad 
Fitzpatrick's tweet for more context).

### `/vendor`
Application dependencies (managed manually or by your favorite dependency management tool 
like the new built-in [`Go Modules`](https://github.com/golang/go/wiki/Modules) feature).  

The `go mod vendor` command will create the `/vendor` directory for you.  

Note that you might need to add the `-mod=vendor` flag to your `go build` command if you 
are not using Go 1.14 where it's on by default.

Don't commit your application dependencies if you are building a library.

Note that since [`1.13`](https://golang.org/doc/go1.13#modules) Go also enabled the module 
proxy feature (using [`https://proxy.golang.org`](https://proxy.golang.org) as their module 
proxy server by default).  

Read more about it [`here`](https://blog.golang.org/module-mirror-launch) to see if it 
fits all of your requirements and constraints.  

If it does, then you won't need the `vendor` directory at all.

## Service Application Directories

### `/api`
OpenAPI/Swagger specs, JSON schema files, protocol definition files.


## Web Application Directories
### `/web`
Web application specific components: static web assets, server side templates and SPAs.


## Common Application Directories
### `/configs`
Configuration file templates or default configs.
Put your `confd` or `consul-template` template files here.


### `/init`
System init (systemd, upstart, sysv) and process manager/supervisor (runit, supervisord) configs.


### `/scripts`
Scripts to perform various build, install, analysis, etc operations.
These scripts keep the root level Makefile small and simple (e.g., [`https://github.com/hashicorp/terraform/blob/main/Makefile`](https://github.com/hashicorp/terraform/blob/main/Makefile)).


### `/build`
Packaging and Continuous Integration.

Put your cloud (AMI), container (Docker), OS (deb, rpm, pkg) package configurations and 
scripts in the `/build/package` directory.

Put your CI (travis, circle, drone) configurations and scripts in the `/build/ci` directory.  

Note that some of the CI tools (e.g., Travis CI) are very picky about the location of 
their config files.  

Try putting the config files in the `/build/ci` directory linking them to the location 
where the CI tools expect them (when possible).


### `/deployments`
IaaS, PaaS, system and container orchestration deployment configurations and templates 
(docker-compose, kubernetes/helm, terraform).  

Note that in some repos (especially apps deployed with kubernetes) this directory is called 
`/deploy`.


### `/test`
Additional external test apps and test data.  

Feel free to structure the `/test` directory anyway you want.  
For bigger projects it makes sense to have a data subdirectory.  

For example, you can have `/test/data` or `/test/testdata` if you need Go to ignore what's 
in that directory.  

Note that Go will also ignore directories or files that begin with `.` or `_`, so you 
have more flexibility in terms of how you name your test data directory.


## Other Directories
### `/docs`
Design and user documents (in addition to your godoc generated documentation).

### `/tools`
Supporting tools for this project.  
Note that these tools can import code from the `/pkg` and `/internal` directories.

### `/examples`
Examples for your applications and/or public libraries.

### `/third_party`
External helper tools, forked code and other 3rd party utilities (e.g., Swagger UI).

### `/githooks`
Git hooks.

### `/assets`
Other assets to go along with your repository (images, logos, etc).

### `/website`
This is the place to put your project's website data if you are not using GitHub pages.



## References
* [Project Layout from golang-standards](https://github.com/golang-standards/project-layout/)  
