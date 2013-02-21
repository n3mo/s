## S

Full documentation for this software package is maintained on the
[Chicken Scheme Wiki](https://wiki.call-cc.org/eggref/4/s).

String manipulation egg for chicken scheme. 

The <i>s</i> egg aims to provide many convenient procedures for
working with strings. Some of these functions are simply wrappers
around existing scheme procedures. In the spirit of s.el, such
wrappers exist to provide users with a consistent API for quickly and
easily manipulating strings in Chicken Scheme without searching
documentation across multiple modules.


Acknowledgments 
===============

This library is mostly a reimplementation of the [Emacs lisp s.el library](https://github.com/magnars/s.el). Most of the procedures retain similar functionality to their elisp equivalent. However, this is a scheme library, so functions behave accordingly (e.g., by returning #f rather than nil).

Bugs & Improvements
===================

Please report any problems that you find, along with any suggestions or contributions.

License
=======

Copyright (C) 2013 Nicholas M. Van Horn

Original Elisp Library Copyright (C) 2012 Magnar Sveen


Author: Nicholas M. Van Horn <vanhorn.nm@gmail.com>

Keywords: chicken, scheme, string

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
