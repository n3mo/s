S
=======

String manipulation egg for chicken scheme. 

This library is currently under active development and is subject to change. The functions defined here were inspired by the Emacs lisp string manipulation library "s" created by Magnar Sveen (and others) at <https://github.com/magnars/s.el>. As such, many procedures are a direct reimplementation of their Elisp counterparts (however, novel procedures have been defined as well). Some of these functions are simply wrappers around existing scheme procedures. In the spirit of s.el, such wrappers exist to provide users with a consistent API for quickly and easily manipulating strings in Chicken Scheme without searching documentation across multiple modules.

Installation
============

<i>S</i> is designed to work with [Chicken Scheme](http://www.call-cc.org/). The procedures were developed and tested on Chicken 4.8.0 and 4.7.0.6. Your mileage may vary on other versions.

<i>S</i> requires the following dependencies/eggs:

<pre>
data-structures
regex
srfi-1
srfi-13
</pre>

<i>S</i> is packaged as a module, but it is currently not available with chicken-install. As such, the only way to "install" this library is to save the source to your local computer (perhaps with the command <code> git clone git://github.com/n3mo/strings.git </code>). Then, issue the command <code>(load "~/path/to/strings.scm")</code> either from the csi REPL or from your source file. After loading, you simply import the module with <code>(import strings)</code> and the procedures described below will become available.

Procedures
==========

### Tweak whitespace

* [s-trim](#procedure-s-trim-s) `(s)`
* [s-trim-left](#procedure-s-trim-left-s) `(s)`
* [s-trim-right](#procedure-s-trim-right-s) `(s)`
* [s-chomp](#procedure-s-chomp-s) `(s)`
* [s-collapse-whitespace](#procedure-s-collapse-whitespace-s) `(s)`
* [s-center](#procedure-s-center-len-s) `(len s)`

### To shorter string

* [s-truncate](#procedure-s-truncate-len-s) `(len s)`
* [s-left](#procedure-s-left-len-s) `(len s)`
* [s-right](#procedure-s-right-len-s) `(len s)`
* [s-chop-suffix](#procedure-s-chop-suffix-suffix-s) `(suffix s)`
* [s-chop-suffixes](#procedure-s-chop-suffixes-suffixes-s) `(suffixes s)`
* [s-chop-prefix](#procedure-s-chop-prefix-prefix-s) `(prefix s)`
* [s-chop-prefixes](#procedure-s-chop-prefixes-prefixes-s) `(prefixes s)`
* [s-shared-start](#procedure-s-shared-start-s1-s2) `(s1 s2)`
* [s-shared-end](#procedure-s-shared-end-s1-s2) `(s1 s2)`

### To longer string

* [s-repeat](#procedure-s-repeat-num-s) `(num s)`
* [s-concat](#procedure-s-concat-rest-strings) `(... strings)`
* [s-prepend](#procedure-s-prepend-prefix-s) `(prefix s)`
* [s-append](#procedure-s-append-suffix-s) `(suffix s)`

### To and from lists

* [s-lines](#procedure-s-lines-s) `(s)`
* [s-match](#procedure-s-match-regexp-s) `(regexp s)`
* [s-match-multiple](#procedure-s-match-multiple-s) `(regexp s)`
* [s-split](#procedure-s-split-s) `(separators s [keepempty])`
* [s-join](#procedure-s-join-separator-strings) `(separator strings)`

### Predicates

* [s-equals?](#procedure-s-equals-s1-s2) `(s1 s2)`
* [s-matches?](#procedure-s-matches-regexp-s) `(regexp s)`
* [s-blank?](#procedure-s-blank-s) `(s)`
* [s-ends-with?](#procedure-s-ends-with-suffix-s-optional-ignore-case) `(suffix s [ignore-case])`
* [s-starts-with?](#procedure-s-starts-with-prefix-s-optional-ignore-case) `(prefix s [ignore-case])`
* [s-contains?](#procedure-s-contains-needle-s-optional-ignore-case) `(needle s [ignore-case])`
* [s-lowercase?](#procedure-s-lowercase-s) `(s)`
* [s-uppercase?](#procedure-s-uppercase-s) `(s)`
* [s-mixedcase?](#procedure-s-mixedcase-s) `(s)`
* [s-capitalized?](#procedure-s-capitalized-s) `(s)`
* [s-titleized?](#procedure-s-titleized-s)`(s)`
* [s-numeric?](#procedure-s-numeric-s) `(s)`

### The misc bucket

* [s-replace](#procedure-s-replace-old-new-s) `(old new s)`
* [s-downcase](#procedure-s-downcase-s) `(s)`
* [s-upcase](#procedure-s-upcase-s) `(s)`
* [s-capitalize](#procedure-s-capitalize-s) `(s)`
* [s-titleize](#procedure-s-titleize-s) `(s)`
* [s-index-of](#procedure-s-index-of-needle-s-optional-ignore-case) `(needle s [ignore-case])`
* [s-reverse](#procedure-s-reverse-s) `(s)`

### Pertaining to words

* [s-split-words](#procedure-s-split-words-s) `(s)`
* [s-lower-camel-case](#procedure-s-lower-camel-case-s) `(s)`
* [s-upper-camel-case](#procedure-s-upper-camel-case-s) `(s)`
* [s-snake-case](#procedure-s-snake-case-s) `(s)`
* [s-dashed-words](#procedure-s-dashed-words-s) `(s)`
* [s-capitalized-words](#procedure-s-capitalized-words-s) `(s)`
* [s-titleized-words](#procedure-s-titleized-words-s) `(s)`
* [s-unique-words](#procedure-s-unique-words-s) `(s)`

## Documentation and examples


### [procedure] `(s-trim s)`

Remove whitespace at the beginning and end of `s`.

```scheme
(s-trim "trim ") ;; => "trim"
(s-trim " this") ;; => "this"
(s-trim " only  trims beg and end  ") ;; => "only  trims beg and end"
```

### [procedure] `(s-trim-left s)`

Remove whitespace at the beginning of `s`.

```scheme
(s-trim-left "trim ") ;; => "trim "
(s-trim-left " this") ;; => "this"
```

### [procedure] `(s-trim-right s)`

Remove whitespace at the end of `s`.

```scheme
(s-trim-right "trim ") ;; => "trim"
(s-trim-right " this") ;; => " this"
```

### [procedure] `(s-chomp s)`

Remove one trailing `\n`, `\r` or `\r\n` from `s`.

```scheme
(s-chomp "no newlines\n") ;; => "no newlines"
(s-chomp "no newlines\r\n") ;; => "no newlines"
(s-chomp "some newlines\n\n") ;; => "some newlines\n"
```

### [procedure] `(s-collapse-whitespace s)`

Convert all adjacent whitespace characters to a single space.

```scheme
(s-collapse-whitespace "only   one space   please") ;; => "only one space please"
(s-collapse-whitespace "collapse \n all \t sorts of \r whitespace") ;; => "collapse all sorts of whitespace"
```

### [procedure] `(s-center len s)`

If `s` is shorter than `len`, pad it with spaces so it is centered.

```scheme
(s-center 5 "a") ;; => "  a  "
(s-center 5 "ab") ;; => "  ab "
(s-center 1 "abc") ;; => "abc"
```


### [procedure] `(s-truncate len s)`

If `s` is longer than `len`, cut it down and add ... at the end.

```scheme
(s-truncate 6 "This is too long") ;; => "Thi..."
(s-truncate 16 "This is also too long") ;; => "This is also ..."
(s-truncate 16 "But this is not!") ;; => "But this is not!"
```

### [procedure] `(s-left len s)`

Returns up to the `len` first chars of `s`.

```scheme
(s-left 3 "lib/file.js") ;; => "lib"
(s-left 3 "li") ;; => "li"
```

### [procedure] `(s-right len s)`

Returns up to the `len` last chars of `s`.

```scheme
(s-right 3 "lib/file.js") ;; => ".js"
(s-right 3 "li") ;; => "li"
```

### [procedure] `(s-chop-suffix suffix s)`

Remove `suffix` if it is at end of `s`.

```scheme
(s-chop-suffix "-test.js" "penguin-test.js") ;; => "penguin"
(s-chop-suffix "\n" "no newlines\n") ;; => "no newlines"
(s-chop-suffix "\n" "some newlines\n\n") ;; => "some newlines\n"
```

### [procedure] `(s-chop-suffixes suffixes s)`

Remove `suffixes` one by one in order, if they are at the end of `s`.

```scheme
(s-chop-suffixes '("_test.js" "-test.js" "Test.js") "penguin-test.js") ;; => "penguin"
(s-chop-suffixes '("\r" "\n") "penguin\r\n") ;; => "penguin\r"
(s-chop-suffixes '("\n" "\r") "penguin\r\n") ;; => "penguin"
```

### [procedure] `(s-chop-prefix prefix s)`

Remove `prefix` if it is at the start of `s`.

```scheme
(s-chop-prefix "/tmp" "/tmp/file.js") ;; => "/file.js"
(s-chop-prefix "/tmp" "/tmp/tmp/file.js") ;; => "/tmp/file.js"
```

### [procedure] `(s-chop-prefixes prefixes s)`

Remove `prefixes` one by one in order, if they are at the start of `s`.

```scheme
(s-chop-prefixes '("/tmp" "/my") "/tmp/my/file.js") ;; => "/file.js"
(s-chop-prefixes '("/my" "/tmp") "/tmp/my/file.js") ;; => "/my/file.js"
```

### [procedure] `(s-shared-start s1 s2)`

Returns the longest prefix `s1` and `s2` have in common.

```scheme
(s-shared-start "bar" "baz") ;; => "ba"
(s-shared-start "foobar" "foo") ;; => "foo"
(s-shared-start "bar" "foo") ;; => ""
```

### [procedure] `(s-shared-end s1 s2)`

Returns the longest suffix `s1` and `s2` have in common.

```scheme
(s-shared-end "bar" "var") ;; => "ar"
(s-shared-end "foo" "foo") ;; => "foo"
(s-shared-end "bar" "foo") ;; => ""
```


### [procedure] `(s-repeat num s)`

Make a string of `s` repeated `num` times.

```scheme
(s-repeat 10 " ") ;; => "          "
(s-concat (s-repeat 8 "Na") " Batman!") ;; => "NaNaNaNaNaNaNaNa Batman!"
```

### [procedure] `(s-concat s ...)`

Join all the string arguments into one string.

```scheme
(s-concat "abc" "def" "ghi") ;; => "abcdefghi"
```

### [procedure] `(s-prepend prefix s)`

Concatenate `prefix` and `s`.

```scheme
(s-prepend "abc" "def") ;; => "abcdef"
```

### [procedure] `(s-append suffix s)`

Concatenate `s` and `suffix`.

```scheme
(s-append "abc" "def") ;; => "defabc"
```


### [procedure] `(s-lines s)`

Splits `s` into a list of strings on newline characters.

```scheme
(s-lines "abc\ndef\nghi") ;; => '("abc" "def" "ghi")
(s-lines "abc\rdef\rghi") ;; => '("abc" "def" "ghi")
(s-lines "abc\r\ndef\r\nghi") ;; => '("abc" "def" "ghi")
```

### [procedure] `(s-match regexp s)`

When the given expression matches the string, this function returns a
list of the whole matching string and a string for each matched
subexpression.  If it did not match the returned value is an empty
list '().

```scheme
(s-match "^def" "abcdefg") ;; => '()
(s-match "^abc" "abcdefg") ;; => '("abc")
(s-match "^.*/([a-z]+).([a-z]+)" "/some/weird/file.html") ;; => '("/some/weird/file.html" "file" "html")
```

### [procedure] `(s-match-multiple regexp s)`

Returns a list of all matches to `regexp` in `s`.
```scheme
(s-match-multiple "[[:digit:]]{4}" "Grab (1234) four-digit (4321) numbers (4567)") ;; => ("1234" "4321" "4567")
(s-match-multiple "<.+?>" "<html> <body> Some text </body> </html>") ;; => ("<html>" "<body>" "</body>" "</html>")
(s-match-multiple "foo-[0-9]{2}" "foo-10 foo-11 foo-1 foo-2 foo-100 foo-21") ;; => ("foo-10" "foo-11" "foo-10" "foo-21")
```

### [procedure] `(s-split separators s [keepempty])`

Splits `s` into substrings bounded by matches for `separators`. If
`keepempty` is #t, zero-length substrings are returned.

```scheme
(s-split " " "one  two  three") ;; => ("one" "two" "three")
(s-split ":" "foo:bar::baz" #t) ;; => ("foo" "bar" "" "baz")
(s-split ":," "foo:bar:baz,quux,zot") ;; => ("foo" "bar" "baz" "quux" "zot")
```

### [procedure] `(s-join separator strings)`

Join all the strings in `strings` with `separator` in between.

```scheme
(s-join "+" '("abc" "def" "ghi")) ;; => "abc+def+ghi"
(s-join "\n" '("abc" "def" "ghi")) ;; => "abc\ndef\nghi"
```

### [procedure] `(s-equals? s1 s2)`

Is `s1` equal to `s2`?

This is a simple wrapper around the built-in `string=`.

```scheme
(s-equals? "abc" "ABC") ;; => #f
(s-equals? "abc" "abc") ;; => #t
```

### [procedure] `(s-matches? regexp s)`

Does `regexp` match `s`?

```scheme
(s-matches? "^[0-9]+$" "123") ;; => #t
(s-matches? "^[0-9]+$" "a123") ;; => #f
```

### [procedure] `(s-blank? s)`

Is `s` the empty string?

```scheme
(s-blank? "") ;; => #t
(s-blank? " ") ;; => #f
```

### [procedure] `(s-ends-with? suffix s [ignore-case])`

Does `s` end with `suffix`?

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

Alias: `s-suffix?`

```scheme
(s-ends-with? ".md" "readme.md") ;; => #t
(s-ends-with? ".MD" "readme.md") ;; => #f
(s-ends-with? ".MD" "readme.md" #t) ;; => #t
```

### [procedure] `(s-starts-with? prefix s [ignore-case])`

Does `s` start with `prefix`?

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

```scheme
(s-starts-with? "lib/" "lib/file.js") ;; => #t
(s-starts-with? "LIB/" "lib/file.js") ;; => #f
(s-starts-with? "LIB/" "lib/file.js" #t) ;; => #t
```

### [procedure] `(s-contains? needle s [ignore-case])`

Does `s` contain `needle`?

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

```scheme
(s-contains? "file" "lib/file.js") ;; => #t
(s-contains? "nope" "lib/file.js") ;; => #f
(s-contains? "^a" "it's not ^a regexp") ;; => #t
```

### [procedure] `(s-lowercase? s)`

Are all the letters in `s` in lower case?

```scheme
(s-lowercase? "file") ;; => #t
(s-lowercase? "File") ;; => #f
(s-lowercase? "123?") ;; => #t
```

### [procedure] `(s-uppercase? s)`

Are all the letters in `s` in upper case?

```scheme
(s-uppercase? "HULK SMASH") ;; => #t
(s-uppercase? "Bruce no smash") ;; => #f
(s-uppercase? "123?") ;; => #t
```

### [procedure] `(s-mixedcase? s)`

Are there both lower case and upper case letters in `s`?

```scheme
(s-mixedcase? "HULK SMASH") ;; => #f
(s-mixedcase? "Bruce no smash") ;; => #t
(s-mixedcase? "123?") ;; => #f
```

### [procedure] `(s-capitalized? s)`
In `s`, is the first letter upper case, and all other letters lower case?
```scheme
(s-capitalized? "Capitalized") ;; => #t
(s-capitalized? "I am capitalized") ;; => #t
(s-capitalized? "I Am Titleized") ;; => #f
```

### [procedure] `(s-titleized? s)`
In s, is the first letter of each word upper case, and all other
letters lower case?
```scheme
(s-titleized? "Titleized") ;; => #t
(s-titleized? "I Am Titleized") ;; => #t
(s-titleized? "I am only capitalized") ;; => #f
```

### [procedure] `(s-numeric? s)`

Is `s` a number?

```scheme
(s-numeric? "123") ;; => #t
(s-numeric? "onetwothree") ;; => #f
```

### [procedure] `(s-replace old new s)`

Replaces `old` with `new` in `s`.

```scheme
(s-replace "file" "nope" "lib/file.js") ;; => "lib/nope.js"
(s-replace "^a" "---" "it's not ^a regexp") ;; => "it's not --- regexp"
```

### [procedure] `(s-downcase s)`

Convert `s` to lower case.

This is a simple wrapper around  `string-downcase`.

```scheme
(s-downcase "ABC") ;; => "abc"
```

### [procedure] `(s-upcase s)`

Convert `s` to upper case.

This is a simple wrapper around `string-upcase`.

```scheme
(s-upcase "abc") ;; => "ABC"
```

### [procedure] `(s-capitalize s)`

Convert the first word's first character to upper case and the rest to lower case in `s`.

```scheme
(s-capitalize "abc DEF") ;; => "Abc def"
(s-capitalize "abc.DEF") ;; => "Abc.def"
```

### [procedure] `(s-titleize s)`

Convert each word's first character to upper case and the rest to lower case in `s`.

This is a simple wrapper around  `string-titlecase`.

```scheme
(s-titleize "abc DEF") ;; => "Abc Def"
(s-titleize "abc.DEF") ;; => "Abc.Def"
```

### [procedure] `(s-index-of needle s [ignore-case])`

Returns first index of `needle` in `s`, or #f.

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

```scheme
(s-index-of "abc" "abcdef") ;; => 0
(s-index-of "CDE" "abcdef" #t) ;; => 2
(s-index-of "n.t" "not a regexp") ;; => #f
```

### [procedure] `(s-reverse s)`

Return the reverse of `s`.

```scheme
(s-reverse "abc") ;; => "cba"
(s-reverse "ab xyz") ;; => "zyx ba"
(s-reverse "") ;; => ""
```

### [procedure] `(s-split-words s)`

Split `s` into list of words.

```scheme
(s-split-words "under_score") ;; => '("under" "score")
(s-split-words "some-dashed-words") ;; => '("some" "dashed" "words")
(s-split-words "evenCamelCase") ;; => '("even" "Camel" "Case")
```

### [procedure] `(s-lower-camel-case s)`

Convert `s` to lowerCamelCase.

```scheme
(s-lower-camel-case "some words") ;; => "someWords"
(s-lower-camel-case "dashed-words") ;; => "dashedWords"
(s-lower-camel-case "under_scored_words") ;; => "underScoredWords"
```

### [procedure] `(s-upper-camel-case s)`

Convert `s` to UpperCamelCase.

```scheme
(s-upper-camel-case "some words") ;; => "SomeWords"
(s-upper-camel-case "dashed-words") ;; => "DashedWords"
(s-upper-camel-case "under_scored_words") ;; => "UnderScoredWords"
```

### [procedure] `(s-snake-case s)`

Convert `s` to snake_case.

```scheme
(s-snake-case "some words") ;; => "some_words"
(s-snake-case "dashed-words") ;; => "dashed_words"
(s-snake-case "camelCasedWords") ;; => "camel_cased_words"
```

### [procedure] `(s-dashed-words s)`

Convert `s` to dashed-words.

```scheme
(s-dashed-words "some words") ;; => "some-words"
(s-dashed-words "under_scored_words") ;; => "under-scored-words"
(s-dashed-words "camelCasedWords") ;; => "camel-cased-words"
```

### [procedure] `(s-capitalized-words s)`

Convert `s` to Capitalized Words.

```scheme
(s-capitalized-words "some words") ;; => "Some words"
(s-capitalized-words "under_scored_words") ;; => "Under scored words"
(s-capitalized-words "camelCasedWords") ;; => "Camel cased words"
```

### [procedure] `(s-titleized-words s)`

Convert `s` to Titleized Words.

```scheme
(s-titleized-words "some words") ;; => "Some Words"
(s-titleized-words "under_scored_words") ;; => "Under Scored Words"
(s-titleized-words "camelCasedWords") ;; => "Camel Cased Words"
```

### [procedure] `(s-unique-words s)`

Return list of unique words in s.

```scheme
(s-unique-words "Forget redundancy about about redundancy") ;; => ("Forget" "about" "redundancy")
(s-unique-words "unique-dashed-words-dashed-words-too") ;; => ("unique" "dashed" "words" "too")
(s-unique-words "camelCase_words and_and underscore_words_too") ;; => ("camel" "Case" "and" "underscore" "words" "too")
```


Acknowledgments 
===============

This library is mostly a reimplementation of the [Emacs lisp s.el library](https://github.com/magnars/s.el). Most of the procedures retain similar functionality to their elisp equivalent. However, this is a scheme library, so functions behave accordingly (e.g., by returning #f rather than nil).

Bugs & Improvements
===================

Please report any problems that you find, along with any suggestions or contributions.

License
=======

Copyright (C) 2013 Nicholas M. Van Horn

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
