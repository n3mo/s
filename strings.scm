;;; These are helper functions for working with strings. Many of these
;;; ideas are a direct port of Magnar Sveen's Elisp string library
;;; (https://github.com/magnars/s.el). Furthermore, many of these
;;; procedures are wrappers around existing functionality meant to
;;; provide a unified string system for users.

;;; TODO: Create these procedures: s-word-wrap, s-match, s-with,
;;; s-format 

;;; TODO: Fix s-capitalize. It currently works ONLY if the first
;;; character of the string also happens to be the first word. If the
;;; first word is preceded by a number, space, tab, etc, this will not
;;; work correctly.

;;; TODO: Fix s-chomp. It currently only removes a trailing \n but not
;;; \r or \r\n

;;; Currently, this library relies on the following extensions.
(require-extension regex)
(require-extension srfi-13)


;;; s-trim (s)
;;; Remove whitespace at the beginning and end of s
(define (s-trim s)
  (string-trim-both s))

;;; s-trim-left (s)
;;; Remove whitespace at the beginning of s
;;; srfi-13 : (string-trim)
(define (s-trim-left s)
  (string-trim s))

;;; s-trim-right (s)
;;; Remove whitespace at the end of s
;;; srfi-13 : (string-trim-right)
(define (s-trim-right s)
  (string-trim-right s))

;;; s-chomp (s)
;;; Remove one trailing \n, \r, or \r\n from s
;;; Unit data-structures: (string-chomp)
(define (s-chomp s)
  (string-chomp s))

;;; s-collapse-whitespace (s)
;;; Convert all adjacent whitespace characters to a single space.
;;; This can be accomplished with the unit regex egg in chicken. I add
;;; this wrapper for convenience
(define (s-collapse-whitespace s)
  (string-substitute "[[:space:]|\r]+" " " s #t))

;;; s-word-wrap (len s)
;;; If s is longer than len, wrap the words with newlines 
;;; This will be tricky to implement in chicken without the
;;; fill-paragraph function of Emacs...

;;; s-center (len s)
;;; If s is shorter than len, pad it with spaces so it is centered.
(define (s-center len s)
  (begin
    (define slen (string-length s))
    (if (>= slen len) s
	(let ((tmp (inexact->exact
		    (round (+ slen (/ (- len slen) 2))))))
	  (string-pad-right (string-pad s tmp) len)))))

;;; s-truncate (len s)
;;; If s is longer than len, cut it down and add ... at the end. 
(define (s-truncate len s)
  (let ((tmp (string->list s)))
    (string-append (list->string (take tmp len)) "...")))

;;; s-left (len s)
;;; Returns up to the len first chars of s.
;;; srfi-13: (string-take s len)
;;; However, string-take raises an exception when (> len
;;; (string-length s)). This wrapper gives functionality similar to
;;; the elisp s-left (returns UP TO len under this situation).
(define (s-left len s)
  (if (> len (string-length s)) s
      (string-take s len)))

;;; s-right (len s)
;;; Returns up to the len last chars of s
;;; srfi-13: (string-take-right s len). see s-left.
(define (s-right len s)
  (if (> len (string-length s)) s
      (string-take-right s len)))

;;; s-chop-suffix (suffix s)
;;; Remove suffix if it is at the end of s.
(define (s-chop-suffix suffix s)
  (string-substitute (string-append suffix "$") "" s))

;;; s-chop-suffixes (suffixes s)
;;; Remove suffixes one by one in order, if they are at the end of s.
(define (s-chop-suffixes suffixes s)
  (cond
   ((null? suffixes) s)
   (else
    (s-chop-suffixes 
     (cdr suffixes) (s-chop-suffix (car suffixes) s)))))

;;; s-chop-prefix (prefix s)
;;; Remove prefix if it is at the start of s
(define (s-chop-prefix prefix s)
  (string-substitute (string-append "^" prefix) "" s))

;;; s-chop-prefixes (prefixes s)
;;; Remove prefixes one by one in order, if they are at the start of
;;; s. 
(define (s-chop-prefixes prefixes s)
  (cond
   ((null? prefixes) s)
   (else
    (s-chop-prefixes
     (cdr prefixes) (s-chop-prefix (car prefixes) s)))))

;;; s-shared-start (s1 s2)
;;; Returns the longest prefix s1 and s2 have in common
(define (s-shared-start s1 s2)
  (string-take s1 (string-prefix-length s1 s2)))

;;; s-shared-end (s1 s2)
;;; Returns the longest suffix s1 and s2 have in common
(define (s-shared-end s1 s2)
  (string-take-right s1 (string-suffix-length s1 s2)))

;;; s-repeat (num s)
;;; Make a string of s repeated num times
(define (s-repeat num s)
	 (cond
	  ((= 0 num) "")
	  (else (string-append s (s-repeat (- num 1) s)))))

;;; s-concat (&rest strings)
;;; Join all the string arguments into one string.
;;; This is a wrapper provided purely for convenience. It offers
;;; nothing new over string-append, and possibly slows it down for
;;; large numbers of strings.
(define s-concat
       (lambda args
	 (apply string-append args)))

;;; s-prepend (prefix s)
;;; Concatenate prefix and s
(define (s-prepend prefix s)
  (string-append prefix s))

;;; s-append (suffix s)
;;; Concatenate s and suffix
(define (s-append suffix s)
  (string-append s suffix))

;;; s-lines (s)
;;; Splits s into a list of strings on newline characters.
(define (s-lines s)
  (string-split s "\n\r"))

;;; s-match (regexp s) 
;;; When the given expression matches the string, this function
;;; returns a list of the whole matching string and a string for each
;;; matched subexpressions. If it did not match the returned value is
;;; an empty list (nil).

;;; TODO

;;; s-join (separator strings)
;;; Join all the strings in strings with separator in between
(define (s-join separator strings)
  (string-join strings separator))

;;; s-equals? (s1 s2)
;;; Is s1 equal to s2?. This is simple wrapper around the built-in
;;; string= 
(define (s-equals? s1 s2)
  (string= s1 s2))

;;; s-matches? (regexp s)
;;; Does regexp match s?
(define (s-matches? regexp s)
  (if (string-match regexp s) #t #f))

;;; n-blank? (s)
;;; Is s null (an empty string)?
(define (s-blank? s)
  (string-null? s))

;;; s-ends-with? (suffix s #!optional ignore-case)
;;; Does s end with suffix? If ignore-case is #t, case comparison is
;;; ignored. 
(define (s-ends-with? suffix s #!optional (ignore-case #f))
  (if ignore-case
      (string-suffix-ci? suffix s)
      (string-suffix? suffix s)))

;;; s-starts-with? (prefix s #!optional ignore-case)
;;; Does s start with suffix? If ignore-case is #t, case comparison is
;;; ignored. 
(define (s-starts-with? prefix s #!optional (ignore-case #f))
  (if ignore-case
      (string-prefix-ci? prefix s)
      (string-prefix? prefix s)))

;;; s-contains? (needle s #!optional ignore-case)
;;; Does s contain needle?. If ignore-case is #t, case comparison is
;;; ignored. 
(define (s-contains? needle s #!optional (ignore-case #f))
  (cond
   (ignore-case
    (if (string-contains s needle)
	#f
	#t))
   (else
    (if (string-contains s needle)
	#t
	#f))))

;;; s-lowercase? (s)
;;; Are all the letters in s in lower case?
(define (s-lowercase? s)
  (s-equals? s (string-downcase s)))

;;; s-uppercase? (s)
;;; Are all the letters in s in upper case?
(define (s-uppercase? s)
  (s-equals? s (string-upcase s)))

;;; s-mixedcase? (s)
;;; Are there both lower case and upper case letters in s?
(define (s-mixedcase? s)
  (if (and (string-match ".*[a-z]+.*" s) 
	   (string-match ".*[A-Z]+.*" s))
      #t
      #f))

;;; s-numeric? (s)
;;; Is s a number?
(define (s-numeric? s)
  (if (string-match "[0-9]+" s) #t #f))

;;; s-replace (old new s)
;;; Replaces old with new in s (old is NOT a regexp)
(define (s-replace old new s)
  (string-substitute (regexp-escape old) new s))

;;; s-downcase (s)
;;; Convert s to lower case
(define (s-downcase s)
  (string-downcase s))

;;; s-upcase (s)
;;; Convert s to upper case
(define (s-upcase s)
  (string-upcase s))

;;; s-capitalize (s)
;;; Convert the first word's first character to upper case and the
;;; rest to lower case in s.
(define (s-capitalize s)
  (list->string 
   (cons 
    (char-upcase (car (string->list s))) 
    (map char-downcase (cdr (string->list s))))))

;;; s-titleize (s)
;;; Convert each word's first character to upper case and the rest to
;;; lower case in s.
(define (s-titleize s)
  (string-titlecase s))

;;; s-with (s form &rest more)
;;; Threads s through the forms. Inserts s as the last item in the
;;; first form, making a list of it if it is not a list already. If
;;; there are more forms, inserts the first form as the last item in
;;; the second form, etc.

;;; s-index-of (needle s #!optional ignore-case)
;;; Returns first index of needle in s, or #f
(define (s-index-of needle s #!optional ignore-case)
  (if ignore-case
      (string-contains-ci s needle)
      (string-contains s needle)))

;;; s-reverse (s)
;;; Return the reverse of s.
(define (s-reverse s)
  (string-reverse s))

;;; s-format (template replacer #!optional extra)
;;; Format template with the function replacer. replacer takes an
;;; argument of the format variable and optionally an extra argument
;;; which is the extra value from the call to s-format. Several
;;; standard s-format helper functions are recognized and adapted for
;;; this: 

;;; s-split-words (s)
;;; Split s into list of words
;;; The string-substitute call converts "camelCase" to "camel Case".
(define (s-split-words s)
  (string-split-fields 
   "\\w+"
   (string-substitute "_+" " " (string-substitute
				"([a-z])([A-Z])"
				"\\1 \\2" s #t) #t)))
;;; s-lower-camel-case (s)
;;; Convert s to lowerCamelCase
(define (s-lower-camel-case s)
  (let ((swords (s-split-words s)))
    (s-join "" (cons 
		(s-downcase (car swords))
		(map s-capitalize (cdr swords))))))

;;; s-upper-camel-case (s)
;;; Convert s to UpperCamelCase
(define (s-upper-camel-case s)
  (s-join "" (map s-capitalize (s-split-words s))))

;;; s-snake-case (s)
;;; Convert s to snake_case
(define (s-snake-case s)
  (s-downcase (s-join "_" (s-split-words s))))

;;; s-dashed-words (s)
;;; Convert s to dashed-words.
(define (s-dashed-words s)
  (s-downcase (s-join "-" (s-split-words s))))

;;; s-capitalized-words (s)
;;; Convert s to Capitalized words.
(define (s-capitalized-words s)
  (s-capitalize (s-join " " (s-split-words s))))

;;; s-titleized-words (s)
;;; Convert s to Titleized Words.
(define (s-titleized-words s)
  (s-titleize (s-join " " (s-split-words s))))

;;; strings.scm ends here.
