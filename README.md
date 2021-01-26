
# Table of Contents

1.  [Introduction](#org6d0a7c7)
2.  [Requirements](#orgd57344d)
3.  [Compiling (or not?)](#org3a59ff2)
4.  [Starting the server](#orgdec8e13)
5.  [Debugging](#org6ade71e)
6.  [License](#org78c3e3e)

An example or template by those who want to host their websites on [Hunchentoot](https://edicl.github.io/hunchentoot) web server.


<a id="org6d0a7c7"></a>

# Introduction

[www.chalaev.com](http://chalaev.com) is my old personal website which I am using to test [Hunchentoot](https://edicl.github.io/hunchentoot).
This project is about *server* (back end) code; the [front end code](srv/www/chalaev.com) serves mostly for demonstration purposes.

The following *server* features are used in [www.chalaev.com](http://chalaev.com):

-   serve static files and generated pages on GET request,
-   basic authentication,
-   customized error pages (e.g. `404.html`),
-   serves `index.html` when asked for `/`, and `file.html` when asked for `file` (requires [hunchentoot update](hunchentoot/hunchentoot.org)).


<a id="orgd57344d"></a>

# Requirements

Usual `linux` environment, `sbcl`, `quicklisp`, `emacs`.

Two `sbcl` packages unavailable in `quicklisp`: [cl-simple-logger](https://github.com/chalaev/cl-simple-logger/blob/master/packaged/simple-log.tbz) and [lisp goodies](https://github.com/chalaev/lisp-goodies/raw/master/packaged/cl-shalaev.tbz), unpacked into your local `quicklisp` repository:

    tar xjf cl-shalaev.tbz --directory=$HOME/quicklisp/local-projects/
    tar xjf simple-log.tbz --directory=$HOME/quicklisp/local-projects/

where it is assimed that your `quicklisp` is installed in `~/quicklisp/`.


<a id="org3a59ff2"></a>

# Compiling (or not?)

Compiling is unnecessary: we could just launch `sbcl` on the server and evaluate

    (ql:quickload :web-server)
    (web-server:start t)

However, I prefer to compile because compilation

-   makes the code faster,
-   saves valuable system resources on the server: e.g., we do not need to install `sbcl` there, and
-   makes it more difficult for <del>Forces of Darkness</del> system administrators to analyze back end code on the server.

[www.chalaev.com](http://chalaev.com) is hosted on a (US-based) VPS server for $2/month;
for this price one enjoys 512Mb of RAM and 10Gb of disk space
which might be enough for small business usage if system resources are used carefully.

`make` compiles the code to a 16Mb binary file which is copied to the server and launched there.
([Manual SBCL compilation](https://github.com/chalaev/cl-simple-logger) with `--with-sb-core-compression` is required to shrink the binary size.)

You probably have to update [Makefile](Makefile) configuration
(specifying where your `sbcl` and `quicklisp` are installed)
to make it work on your system.


<a id="orgdec8e13"></a>

# Starting the server

Apart from code from this project we also need

1.  [certbot](https://duckduckgo.com/?t=ffsb&q=certbot&ia=web) to obtain our SSL-certificates, and
2.  [nginx](https://nginx.org/en/) as a proxy.

Configuring `certbot` and `nginx` is discussed elsewhere;
The specific configuration file responsible for [www.chalaev.com](http://chalaev.com) 
resides in [/etc/nginx/sites-enabled/chalaev.com](generated/chalaev-com.nginx)


<a id="org6ade71e"></a>

# Debugging

[Swank](https://quickref.common-lisp.net/swank.html) allows to connect to the (remote) code and update it (or change variables' values) without actually restarting the server.
Since we do not want to open 4005th port on the server, let us tunnel it to the 4015th one on the local host:

    ssh -o ControlMaster=auto -o ControlPath=/tmp/chalaev.%C -L 4015:localhost:4005 -fN chalaev.com
    ssh -o ControlMaster=auto -o ControlPath=/tmp/chalaev.%C -O check chalaev.com

(You might want to update your [~/.ssh/config](https://github.com/chalaev/cloud/blob/master/cloud.org) file to improve connection reliability.)

Then in local `emacs` we

    M-x slime-connect
    localhost
    4015

After that, we just use [slime](https://common-lisp.net/project/slime/) for debugging, just as for locally running code,
but feeling almost like [debugging the Deep Space 1 spacecraft](https://lispcookbook.github.io/cl-cookbook/debugging.html) ☺.


<a id="org78c3e3e"></a>

# License

This code is released under [MIT license](https://mit-license.org/).

