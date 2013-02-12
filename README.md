Strings
=======

String manipulation egg for chicken scheme. 

This library is currently under active development and is subject to change. The functions defined here are ported directly from the Emacs lisp string manipulation library "s" created by Magnar Sveen (and others) at <https://github.com/magnars/s.el>. Many of these functions are simply wrappers around existing scheme procedures. They are provided as a single, consistent system for quickly and easily manipulating strings in Chicken Scheme.

Installation
============

<i>Strings</i> is designed to work with [Chicken Scheme](http://www.call-cc.org/). The procedures were developed and tested on Chicken 4.8.0 and 4.7.0.6. Your mileage may vary on other versions.

<i>Strings</i> requires the following dependencies/eggs:

<code>
(require-extension regex)
(require-extension srfi-13)
</code>

Currently, the only way to "install" this library is to save the source to your local computer  <code> git clone git://github.com/n3mo/strings.git </code>. Then, issue the command <code>(load "~/path/to/strings.scm")</code> either from the csi REPL or from your source file.

Procedures
==========

The available procedures will documented here... 
