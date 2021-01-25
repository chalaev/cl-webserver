
# Table of Contents

1.  [Introduction](#org0781387)
2.  [Requirements](#org37c9756)
3.  [Hosting](#org754b3c5)
4.  [Compiling (or not?)](#org439ba27)
5.  [Debugging](#orga489bc6)
6.  [License](#org65b6660)



<a id="org0781387"></a>

# Introduction

[www.chalaev.com](http://chalaev.com) is my old personal website which I am using to test [Hunchentoot](https://edicl.github.io/hunchentoot).
This project is about *server* (back end) code; the [front end code](chalaev.com/) serves mostly for demonstration purposes.

The following *server* features work:

-   serve static files on GET request,
-   basic authentication,
-   customized error pages (e.g. `404.html`),
-   serves `index.html` when asked for `/`, and `file.html` when asked for `file` (requires [hunchentoot update](hunchentoot/)).


<a id="org37c9756"></a>

# Requirements

Usual `linux` environment, `sbcl`, `quicklisp`, `emacs`, and [lisp goodies](https://github.com/chalaev/lisp-goodies/raw/master/packaged/cl-shalaev.tbz) unpacked into your local `quicklisp` repository.


<a id="org754b3c5"></a>

# Hosting

The website is hosted on a (US-based) VPS server for \\$2/month;
for this price one enjoys 512Mb of RAM and 10Gb of disk space
which might be enough for small business usage if system resources are used carefully.


<a id="org439ba27"></a>

# Compiling (or not?)

Compiling is unnecessary: we could just launch `sbcl` on the server and evaluate

    (ql:quickload :web-server)
    (web-server:start t)

However, I prefer to compile because compilation

-   makes the code faster,
-   saves valuable system resources on the server: e.g., we do not need to install `sbcl` there, and
-   makes it more difficult for <del>Forces of Darkness</del> system administrators to analyze back end code on the server.

`make` compiles the code to a 16Mb binary file which is copied to the server and launched there.

You probably have to update [Makefile](Makefile) configuration
(specifying where your `sbcl` and `quicklisp` are installed)
to make it work on your system.


<a id="orga489bc6"></a>

# Debugging

[Swank](https://quickref.common-lisp.net/swank.html) allows to connect to the (remote) code and update it (or change variables' values) without actually restarting the server.
Since we do not want to open 4005th port on the server, let me tunnel it to the 4015th one on my local host:

    ssh -o ControlMaster=auto -o ControlPath=/tmp/chalaev.%C -L 4015:localhost:4005 -fN chalaev.com
    ssh -o ControlMaster=auto -o ControlPath=/tmp/chalaev.%C -O check chalaev.com

(You might want to update your [~/.ssh/config](https://github.com/chalaev/cloud/blob/master/cloud.org) file to improve connection reliability.)

Then in local `emacs` we

    M-x slime-connect
    localhost
    4015

After that, we just use [slime](https://common-lisp.net/project/slime/) for debugging, just as for locally running code,
but feeling almost like [debugging the Deep Space 1 spacecraft](https://lispcookbook.github.io/cl-cookbook/debugging.html) ☺.


<a id="org65b6660"></a>

# License

This code is released under [MIT license](https://mit-license.org/).

