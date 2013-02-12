Strings
=======

String manipulation egg for chicken scheme. 

This library is currently under active development and is subject to change. The functions defined here are ported directly from the Emacs lisp string manipulation library "s" created by Magnar Sveen (and others) at <https://github.com/magnars/s.el>. Many of these functions are simply wrappers around existing scheme procedures. In the spirit of s.el, they provide users with a consistent API for quickly and easily manipulating strings in Chicken Scheme without searching documentation across multiple modules.

Installation
============

<i>Strings</i> is designed to work with [Chicken Scheme](http://www.call-cc.org/). The procedures were developed and tested on Chicken 4.8.0 and 4.7.0.6. Your mileage may vary on other versions.

<i>Strings</i> requires the following dependencies/eggs:

<pre>
regex
srfi-13
</pre>

Currently, the only way to "install" this library is to save the source to your local computer  <code> git clone git://github.com/n3mo/strings.git </code>. Then, issue the command <code>(load "~/path/to/strings.scm")</code> either from the csi REPL or from your source file. If you load the procedures independently, note that you will need to load the dependencies yourself by adding <code>(require-extension regex srfi-13)</code>, or equivalent to your code.

Procedures
==========

### Tweak whitespace

* [s-trim](#s-trim-s) `(s)`
* [s-trim-left](#s-trim-left-s) `(s)`
* [s-trim-right](#s-trim-right-s) `(s)`
* [s-chomp](#s-chomp-s) `(s)`
* [s-collapse-whitespace](#s-collapse-whitespace-s) `(s)`
* [s-word-wrap](#s-word-wrap-len-s) `(len s)`
* [s-center](#s-center-len-s) `(len s)`

### To shorter string

* [s-truncate](#s-truncate-len-s) `(len s)`
* [s-left](#s-left-len-s) `(len s)`
* [s-right](#s-right-len-s) `(len s)`
* [s-chop-suffix](#s-chop-suffix-suffix-s) `(suffix s)`
* [s-chop-suffixes](#s-chop-suffixes-suffixes-s) `(suffixes s)`
* [s-chop-prefix](#s-chop-prefix-prefix-s) `(prefix s)`
* [s-chop-prefixes](#s-chop-prefixes-prefixes-s) `(prefixes s)`
* [s-shared-start](#s-shared-start-s1-s2) `(s1 s2)`
* [s-shared-end](#s-shared-end-s1-s2) `(s1 s2)`

### To longer string

* [s-repeat](#s-repeat-num-s) `(num s)`
* [s-concat](#s-concat-rest-strings) `(&rest strings)`
* [s-prepend](#s-prepend-prefix-s) `(prefix s)`
* [s-append](#s-append-suffix-s) `(suffix s)`

### To and from lists

* [s-lines](#s-lines-s) `(s)`
* [s-match](#s-match-regexp-s) `(regexp s)`
* [s-join](#s-join-separator-strings) `(separator strings)`

### Predicates

* [s-equals?](#s-equals-s1-s2) `(s1 s2)`
* [s-matches?](#s-matches-regexp-s) `(regexp s)`
* [s-blank?](#s-blank-s) `(s)`
* [s-ends-with?](#s-ends-with-suffix-s-optional-ignore-case) `(suffix s #!optional ignore-case)`
* [s-starts-with?](#s-starts-with-prefix-s-optional-ignore-case) `(prefix s #!optional ignore-case)`
* [s-contains?](#s-contains-needle-s-optional-ignore-case) `(needle s #!optional ignore-case)`
* [s-lowercase?](#s-lowercase-s) `(s)`
* [s-uppercase?](#s-uppercase-s) `(s)`
* [s-mixedcase?](#s-mixedcase-s) `(s)`
* [s-numeric?](#s-numeric-s) `(s)`

### The misc bucket

* [s-replace](#s-replace-old-new-s) `(old new s)`
* [s-downcase](#s-downcase-s) `(s)`
* [s-upcase](#s-upcase-s) `(s)`
* [s-capitalize](#s-capitalize-s) `(s)`
* [s-titleize](#s-titleize-s) `(s)`
* [s-with](#s-with-s-form-rest-more) `(s form &rest more)`
* [s-index-of](#s-index-of-needle-s-optional-ignore-case) `(needle s #!optional ignore-case)`
* [s-reverse](#s-reverse-s) `(s)`
* [s-format](#s-format-template-replacer-optional-extra) `(template replacer #!optional extra)`

### Pertaining to words

* [s-split-words](#s-split-words-s) `(s)`
* [s-lower-camel-case](#s-lower-camel-case-s) `(s)`
* [s-upper-camel-case](#s-upper-camel-case-s) `(s)`
* [s-snake-case](#s-snake-case-s) `(s)`
* [s-dashed-words](#s-dashed-words-s) `(s)`
* [s-capitalized-words](#s-capitalized-words-s) `(s)`
* [s-titleized-words](#s-titleized-words-s) `(s)`

## Documentation and examples


### s-trim `(s)`

Remove whitespace at the beginning and end of `s`.

```scheme
(s-trim "trim ") ;; => "trim"
(s-trim " this") ;; => "this"
(s-trim " only  trims beg and end  ") ;; => "only  trims beg and end"
```

### s-trim-left `(s)`

Remove whitespace at the beginning of `s`.

```cl
(s-trim-left "trim ") ;; => "trim "
(s-trim-left " this") ;; => "this"
```

### s-trim-right `(s)`

Remove whitespace at the end of `s`.

```cl
(s-trim-right "trim ") ;; => "trim"
(s-trim-right " this") ;; => " this"
```

### s-chomp `(s)`

Remove one trailing `\n`, `\r` or `\r\n` from `s`.

```cl
(s-chomp "no newlines\n") ;; => "no newlines"
(s-chomp "no newlines\r\n") ;; => "no newlines"
(s-chomp "some newlines\n\n") ;; => "some newlines\n"
```

### s-collapse-whitespace `(s)`

Convert all adjacent whitespace characters to a single space.

```cl
(s-collapse-whitespace "only   one space   please") ;; => "only one space please"
(s-collapse-whitespace "collapse \n all \t sorts of \r whitespace") ;; => "collapse all sorts of whitespace"
```

### s-word-wrap `(len s)`

If `s` is longer than `len`, wrap the words with newlines.

```cl
(s-word-wrap 10 "This is too long") ;; => "This is\ntoo long"
(s-word-wrap 10 "This is way way too long") ;; => "This is\nway way\ntoo long"
(s-word-wrap 10 "It-wraps-words-but-does-not-break-them") ;; => "It-wraps-words-but-does-not-break-them"
```

### s-center `(len s)`

If `s` is shorter than `len`, pad it with spaces so it is centered.

```cl
(s-center 5 "a") ;; => "  a  "
(s-center 5 "ab") ;; => "  ab "
(s-center 1 "abc") ;; => "abc"
```


### s-truncate `(len s)`

If `s` is longer than `len`, cut it down and add ... at the end.

```cl
(s-truncate 6 "This is too long") ;; => "Thi..."
(s-truncate 16 "This is also too long") ;; => "This is also ..."
(s-truncate 16 "But this is not!") ;; => "But this is not!"
```

### s-left `(len s)`

Returns up to the `len` first chars of `s`.

```cl
(s-left 3 "lib/file.js") ;; => "lib"
(s-left 3 "li") ;; => "li"
```

### s-right `(len s)`

Returns up to the `len` last chars of `s`.

```cl
(s-right 3 "lib/file.js") ;; => ".js"
(s-right 3 "li") ;; => "li"
```

### s-chop-suffix `(suffix s)`

Remove `suffix` if it is at end of `s`.

```cl
(s-chop-suffix "-test.js" "penguin-test.js") ;; => "penguin"
(s-chop-suffix "\n" "no newlines\n") ;; => "no newlines"
(s-chop-suffix "\n" "some newlines\n\n") ;; => "some newlines\n"
```

### s-chop-suffixes `(suffixes s)`

Remove `suffixes` one by one in order, if they are at the end of `s`.

```cl
(s-chop-suffixes '("_test.js" "-test.js" "Test.js") "penguin-test.js") ;; => "penguin"
(s-chop-suffixes '("\r" "\n") "penguin\r\n") ;; => "penguin\r"
(s-chop-suffixes '("\n" "\r") "penguin\r\n") ;; => "penguin"
```

### s-chop-prefix `(prefix s)`

Remove `prefix` if it is at the start of `s`.

```cl
(s-chop-prefix "/tmp" "/tmp/file.js") ;; => "/file.js"
(s-chop-prefix "/tmp" "/tmp/tmp/file.js") ;; => "/tmp/file.js"
```

### s-chop-prefixes `(prefixes s)`

Remove `prefixes` one by one in order, if they are at the start of `s`.

```cl
(s-chop-prefixes '("/tmp" "/my") "/tmp/my/file.js") ;; => "/file.js"
(s-chop-prefixes '("/my" "/tmp") "/tmp/my/file.js") ;; => "/my/file.js"
```

### s-shared-start `(s1 s2)`

Returns the longest prefix `s1` and `s2` have in common.

```cl
(s-shared-start "bar" "baz") ;; => "ba"
(s-shared-start "foobar" "foo") ;; => "foo"
(s-shared-start "bar" "foo") ;; => ""
```

### s-shared-end `(s1 s2)`

Returns the longest suffix `s1` and `s2` have in common.

```cl
(s-shared-end "bar" "var") ;; => "ar"
(s-shared-end "foo" "foo") ;; => "foo"
(s-shared-end "bar" "foo") ;; => ""
```


### s-repeat `(num s)`

Make a string of `s` repeated `num` times.

```cl
(s-repeat 10 " ") ;; => "          "
(s-concat (s-repeat 8 "Na") " Batman!") ;; => "NaNaNaNaNaNaNaNa Batman!"
```

### s-concat `(&rest strings)`

Join all the string arguments into one string.

```cl
(s-concat "abc" "def" "ghi") ;; => "abcdefghi"
```

### s-prepend `(prefix s)`

Concatenate `prefix` and `s`.

```cl
(s-prepend "abc" "def") ;; => "abcdef"
```

### s-append `(suffix s)`

Concatenate `s` and `suffix`.

```cl
(s-append "abc" "def") ;; => "defabc"
```


### s-lines `(s)`

Splits `s` into a list of strings on newline characters.

```cl
(s-lines "abc\ndef\nghi") ;; => '("abc" "def" "ghi")
(s-lines "abc\rdef\rghi") ;; => '("abc" "def" "ghi")
(s-lines "abc\r\ndef\r\nghi") ;; => '("abc" "def" "ghi")
```

### s-match `(regexp s)`

When the given expression matches the string, this function returns a list
of the whole matching string and a string for each matched subexpressions.
If it did not match the returned value is an empty list '().

```cl
(s-match "^def" "abcdefg") ;; => '()
(s-match "^abc" "abcdefg") ;; => '("abc")
(s-match "^/.*/\\([a-z]+\\)\\.\\([a-z]+\\)" "/some/weird/file.html") ;; => '("/some/weird/file.html" "file" "html")
```

### s-join `(separator strings)`

Join all the strings in `strings` with `separator` in between.

```cl
(s-join "+" '("abc" "def" "ghi")) ;; => "abc+def+ghi"
(s-join "\n" '("abc" "def" "ghi")) ;; => "abc\ndef\nghi"
```


### s-equals? `(s1 s2)`

Is `s1` equal to `s2`?

This is a simple wrapper around the built-in `string-equal`.

```cl
(s-equals? "abc" "ABC") ;; => #f
(s-equals? "abc" "abc") ;; => #t
```

### s-matches? `(regexp s)`

Does `regexp` match `s`?

This is a simple wrapper around the built-in `string-match-p`.

```cl
(s-matches? "^[0-9]+$" "123") ;; => #t
(s-matches? "^[0-9]+$" "a123") ;; => #f
```

### s-blank? `(s)`

Is `s` the empty string?

```cl
(s-blank? "") ;; => #t
(s-blank? " ") ;; => #f
```

### s-ends-with? `(suffix s #!optional ignore-case)`

Does `s` end with `suffix`?

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

Alias: `s-suffix?`

```cl
(s-ends-with? ".md" "readme.md") ;; => #t
(s-ends-with? ".MD" "readme.md") ;; => #f
(s-ends-with? ".MD" "readme.md" t) ;; => #t
```

### s-starts-with? `(prefix s #!optional ignore-case)`

Does `s` start with `prefix`?

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

Alias: `s-prefix?`. This is a simple wrapper around the built-in
`string-prefix-p`.

```cl
(s-starts-with? "lib/" "lib/file.js") ;; => #t
(s-starts-with? "LIB/" "lib/file.js") ;; => #f
(s-starts-with? "LIB/" "lib/file.js" t) ;; => #t
```

### s-contains? `(needle s #!optional ignore-case)`

Does `s` contain `needle`?

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

```cl
(s-contains? "file" "lib/file.js") ;; => #t
(s-contains? "nope" "lib/file.js") ;; => #f
(s-contains? "^a" "it's not ^a regexp") ;; => #t
```

### s-lowercase? `(s)`

Are all the letters in `s` in lower case?

```cl
(s-lowercase? "file") ;; => #t
(s-lowercase? "File") ;; => #f
(s-lowercase? "123?") ;; => #t
```

### s-uppercase? `(s)`

Are all the letters in `s` in upper case?

```cl
(s-uppercase? "HULK SMASH") ;; => #t
(s-uppercase? "Bruce no smash") ;; => #f
(s-uppercase? "123?") ;; => #t
```

### s-mixedcase? `(s)`

Are there both lower case and upper case letters in `s`?

```cl
(s-mixedcase? "HULK SMASH") ;; => #f
(s-mixedcase? "Bruce no smash") ;; => #t
(s-mixedcase? "123?") ;; => #f
```

### s-numeric? `(s)`

Is `s` a number?

```cl
(s-numeric? "123") ;; => #t
(s-numeric? "onetwothree") ;; => #f
```


### s-replace `(old new s)`

Replaces `old` with `new` in `s`.

```cl
(s-replace "file" "nope" "lib/file.js") ;; => "lib/nope.js"
(s-replace "^a" "\\1" "it's not ^a regexp") ;; => "it's not \\1 regexp"
```

### s-downcase `(s)`

Convert `s` to lower case.

This is a simple wrapper around the built-in `downcase`.

```cl
(s-downcase "ABC") ;; => "abc"
```

### s-upcase `(s)`

Convert `s` to upper case.

This is a simple wrapper around the built-in `upcase`.

```cl
(s-upcase "abc") ;; => "ABC"
```

### s-capitalize `(s)`

Convert the first word's first character to upper case and the rest to lower case in `s`.

```cl
(s-capitalize "abc DEF") ;; => "Abc def"
(s-capitalize "abc.DEF") ;; => "Abc.def"
```

### s-titleize `(s)`

Convert each word's first character to upper case and the rest to lower case in `s`.

This is a simple wrapper around the built-in `capitalize`.

```cl
(s-titleize "abc DEF") ;; => "Abc Def"
(s-titleize "abc.DEF") ;; => "Abc.Def"
```

### s-with `(s form &rest more)`

Threads `s` through the forms. Inserts `s` as the last item
in the first form, making a list of it if it is not a list
already. If there are more forms, inserts the first form as the
last item in second form, etc.

```cl
(s-with "   hulk smash   " s-trim s-upcase) ;; => "HULK SMASH"
(s-with "My car is a Toyota" (s-replace "car" "name") (s-replace "a Toyota" "Bond") (s-append ", James Bond")) ;; => "My name is Bond, James Bond"
(s-with "abc \ndef  \nghi" s-lines (mapcar 's-trim) (s-join "-") s-reverse) ;; => "ihg-fed-cba"
```

### s-index-of `(needle s #!optional ignore-case)`

Returns first index of `needle` in `s`, or #f.

If `ignore-case` is non-#f, the comparison is done without paying
attention to case differences.

```cl
(s-index-of "abc" "abcdef") ;; => 0
(s-index-of "CDE" "abcdef" t) ;; => 2
(s-index-of "n.t" "not a regexp") ;; => #f
```

### s-reverse `(s)`

Return the reverse of `s`.

```cl
(s-reverse "abc") ;; => "cba"
(s-reverse "ab xyz") ;; => "zyx ba"
(s-reverse "") ;; => ""
```

### s-format `(template replacer #!optional extra)`

Format `template` with the function `replacer`.

`replacer` takes an argument of the format variable and optionally
an extra argument which is the `extra` value from the call to
`s-format`.

Several standard `s-format` helper functions are recognized and
adapted for this:

    (s-format "${name}" 'gethash hash-table)
    (s-format "${name}" 'aget alist)
    (s-format "$0" 'elt sequence)

The `replacer` function may be used to do any other kind of
transformation.

```cl
(s-format "help ${name}! I'm ${malady}" 'aget '(("name" . "nic") ("malady" . "on fire"))) ;; => "help nic! I'm on fire"
(s-format "hello ${name}, nice day" (lambda (var-name) "nic")) ;; => "hello nic, nice day"
(s-format "hello $0, nice $1" 'elt '("nic" "day")) ;; => "hello nic, nice day"
```


### s-split-words `(s)`

Split `s` into list of words.

```cl
(s-split-words "under_score") ;; => '("under" "score")
(s-split-words "some-dashed-words") ;; => '("some" "dashed" "words")
(s-split-words "evenCamelCase") ;; => '("even" "Camel" "Case")
```

### s-lower-camel-case `(s)`

Convert `s` to lowerCamelCase.

```cl
(s-lower-camel-case "some words") ;; => "someWords"
(s-lower-camel-case "dashed-words") ;; => "dashedWords"
(s-lower-camel-case "under_scored_words") ;; => "underScoredWords"
```

### s-upper-camel-case `(s)`

Convert `s` to UpperCamelCase.

```cl
(s-upper-camel-case "some words") ;; => "SomeWords"
(s-upper-camel-case "dashed-words") ;; => "DashedWords"
(s-upper-camel-case "under_scored_words") ;; => "UnderScoredWords"
```

### s-snake-case `(s)`

Convert `s` to snake_case.

```cl
(s-snake-case "some words") ;; => "some_words"
(s-snake-case "dashed-words") ;; => "dashed_words"
(s-snake-case "camelCasedWords") ;; => "camel_cased_words"
```

### s-dashed-words `(s)`

Convert `s` to dashed-words.

```cl
(s-dashed-words "some words") ;; => "some-words"
(s-dashed-words "under_scored_words") ;; => "under-scored-words"
(s-dashed-words "camelCasedWords") ;; => "camel-cased-words"
```

### s-capitalized-words `(s)`

Convert `s` to Capitalized Words.

```cl
(s-capitalized-words "some words") ;; => "Some words"
(s-capitalized-words "under_scored_words") ;; => "Under scored words"
(s-capitalized-words "camelCasedWords") ;; => "Camel cased words"
```

### s-titleized-words `(s)`

Convert `s` to Titleized Words.

```cl
(s-titleized-words "some words") ;; => "Some Words"
(s-titleized-words "under_scored_words") ;; => "Under Scored Words"
(s-titleized-words "camelCasedWords") ;; => "Camel Cased Words"
```
