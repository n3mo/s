;;; Tests for strings module.

(use strings srfi-13 regex)

;; Tests begin here
(s-trim "trim ") ;; => "trim"
(s-trim " this") ;; => "this"
(s-trim " only  trims beg and end  ") ;; => "only  trims beg and end"

(s-trim-left "trim ") ;; => "trim "
(s-trim-left " this") ;; => "this"

(s-trim-right "trim ") ;; => "trim"
(s-trim-right " this") ;; => " this"

(s-chomp "no newlines\n") ;; => "no newlines"
(s-chomp "no newlines\r\n") ;; => "no newlines"
(s-chomp "some newlines\n\n") ;; => "some newlines\n"

(s-collapse-whitespace "only   one space   please") ;; => "only one space please"
(s-collapse-whitespace "collapse \n all \t sorts of \r whitespace") ;; => "collapse all sorts of whitespace"

(s-center 5 "a") ;; => "  a  "
(s-center 5 "ab") ;; => "  ab "
(s-center 1 "abc") ;; => "abc"

(s-truncate 6 "This is too long") ;; => "Thi..."
(s-truncate 16 "This is also too long") ;; => "This is also ..."
(s-truncate 16 "But this is not!") ;; => "But this is not!"

(s-left 3 "lib/file.js") ;; => "lib"
(s-left 3 "li") ;; => "li"

(s-right 3 "lib/file.js") ;; => ".js"
(s-right 3 "li") ;; => "li"

(s-chop-suffix "-test.js" "penguin-test.js") ;; => "penguin"
(s-chop-suffix "\n" "no newlines\n") ;; => "no newlines"
(s-chop-suffix "\n" "some newlines\n\n") ;; => "some newlines\n"

(s-chop-suffixes '("_test.js" "-test.js" "Test.js") "penguin-test.js") ;; => "penguin"
(s-chop-suffixes '("\r" "\n") "penguin\r\n") ;; => "penguin\r"
(s-chop-suffixes '("\n" "\r") "penguin\r\n") ;; => "penguin"

(s-chop-prefix "/tmp" "/tmp/file.js") ;; => "/file.js"
(s-chop-prefix "/tmp" "/tmp/tmp/file.js") ;; => "/tmp/file.js"

(s-chop-prefixes '("/tmp" "/my") "/tmp/my/file.js") ;; => "/file.js"
(s-chop-prefixes '("/my" "/tmp") "/tmp/my/file.js") ;; => "/my/file.js"

(s-shared-start "bar" "baz") ;; => "ba"
(s-shared-start "foobar" "foo") ;; => "foo"
(s-shared-start "bar" "foo") ;; => ""

(s-shared-end "bar" "var") ;; => "ar"
(s-shared-end "foo" "foo") ;; => "foo"
(s-shared-end "bar" "foo") ;; => ""

(s-repeat 10 " ") ;; => "          "
(s-concat (s-repeat 8 "Na") " Batman!") ;; => "NaNaNaNaNaNaNaNa Batman!"

(s-concat "abc" "def" "ghi") ;; => "abcdefghi"

(s-prepend "abc" "def") ;; => "abcdef"

(s-append "abc" "def") ;; => "defabc"

(s-lines "abc\ndef\nghi") ;; => '("abc" "def" "ghi")
(s-lines "abc\rdef\rghi") ;; => '("abc" "def" "ghi")
(s-lines "abc\r\ndef\r\nghi") ;; => '("abc" "def" "ghi")

(s-match "^def" "abcdefg") ;; => '()
(s-match "^abc" "abcdefg") ;; => '("abc")
(s-match "^.*/([a-z]+).([a-z]+)" "/some/weird/file.html") ;; => '("/some/weird/file.html" "file" "html")

(s-match-multiple "[[:digit:]]{4}" "Grab (1234) four-digit (4321) numbers (4567)") ;; => ("1234" "4321" "4567")
(s-match-multiple "<.+?>" "<html> <body> Some text </body> </html>") ;; => ("<html>" "<body>" "</body>" "</html>")
(s-match-multiple "foo-[0-9]{2}" "foo-10 foo-11 foo-1 foo-2 foo-100 foo-21") ;; => ("foo-10" "foo-11" "foo-10" "foo-21")

(s-split " " "one  two  three") ;; => ("one" "two" "three")
(s-split ":" "foo:bar::baz" #t) ;; => ("foo" "bar" "" "baz")
(s-split ":," "foo:bar:baz,quux,zot") ;; => ("foo" "bar" "baz" "quux" "zot")

(s-join "+" '("abc" "def" "ghi")) ;; => "abc+def+ghi"
(s-join "\n" '("abc" "def" "ghi")) ;; => "abc\ndef\nghi"

(s-equals? "abc" "ABC") ;; => #f
(s-equals? "abc" "abc") ;; => #t

(s-matches? "^[0-9]+$" "123") ;; => #t
(s-matches? "^[0-9]+$" "a123") ;; => #f

(s-blank? "") ;; => #t
(s-blank? " ") ;; => #f

(s-ends-with? ".md" "readme.md") ;; => #t
(s-ends-with? ".MD" "readme.md") ;; => #f
(s-ends-with? ".MD" "readme.md" #t) ;; => #t

(s-starts-with? "lib/" "lib/file.js") ;; => #t
(s-starts-with? "LIB/" "lib/file.js") ;; => #f
(s-starts-with? "LIB/" "lib/file.js" #t) ;; => #t

(s-contains? "file" "lib/file.js") ;; => #t
(s-contains? "nope" "lib/file.js") ;; => #f
(s-contains? "^a" "it's not ^a regexp") ;; => #t

(s-lowercase? "file") ;; => #t
(s-lowercase? "File") ;; => #f
(s-lowercase? "123?") ;; => #t

(s-uppercase? "HULK SMASH") ;; => #t
(s-uppercase? "Bruce no smash") ;; => #f
(s-uppercase? "123?") ;; => #t

(s-mixedcase? "HULK SMASH") ;; => #f
(s-mixedcase? "Bruce no smash") ;; => #t
(s-mixedcase? "123?") ;; => #f

(s-capitalized? "Capitalized") ;; => #t
(s-capitalized? "I am capitalized") ;; => #t
(s-capitalized? "I Am Titleized") ;; => #f

(s-numeric? "123") ;; => #t
(s-numeric? "onetwothree") ;; => #f

(s-replace "file" "nope" "lib/file.js") ;; => "lib/nope.js"
(s-replace "^a" "---" "it's not ^a regexp") ;; => "it's not --- regexp"

(s-downcase "ABC") ;; => "abc"

(s-upcase "abc") ;; => "ABC"

(s-capitalize "abc DEF") ;; => "Abc def"
(s-capitalize "abc.DEF") ;; => "Abc.def"

(s-titleize "abc DEF") ;; => "Abc Def"
(s-titleize "abc.DEF") ;; => "Abc.Def"

(s-index-of "abc" "abcdef") ;; => 0
(s-index-of "CDE" "abcdef" #t) ;; => 2
(s-index-of "n.t" "not a regexp") ;; => #f

(s-reverse "abc") ;; => "cba"
(s-reverse "ab xyz") ;; => "zyx ba"
(s-reverse "") ;; => ""

(s-split-words "under_score") ;; => '("under" "score")
(s-split-words "some-dashed-words") ;; => '("some" "dashed" "words")
(s-split-words "evenCamelCase") ;; => '("even" "Camel" "Case")

(s-lower-camel-case "some words") ;; => "someWords"
(s-lower-camel-case "dashed-words") ;; => "dashedWords"
(s-lower-camel-case "under_scored_words") ;; => "underScoredWords"

(s-upper-camel-case "some words") ;; => "SomeWords"
(s-upper-camel-case "dashed-words") ;; => "DashedWords"
(s-upper-camel-case "under_scored_words") ;; => "UnderScoredWords"

(s-snake-case "some words") ;; => "some_words"
(s-snake-case "dashed-words") ;; => "dashed_words"
(s-snake-case "camelCasedWords") ;; => "camel_cased_words"

(s-dashed-words "some words") ;; => "some-words"
(s-dashed-words "under_scored_words") ;; => "under-scored-words"
(s-dashed-words "camelCasedWords") ;; => "camel-cased-words"

(s-capitalized-words "some words") ;; => "Some words"
(s-capitalized-words "under_scored_words") ;; => "Under scored words"
(s-capitalized-words "camelCasedWords") ;; => "Camel cased words"

(s-titleized-words "some words") ;; => "Some Words"
(s-titleized-words "under_scored_words") ;; => "Under Scored Words"
(s-titleized-words "camelCasedWords") ;; => "Camel Cased Words"

;;; end of file run.scm
