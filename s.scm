;;; s.scm --- Strings Egg For Chicken Scheme

;; Copyright 2013, Nicholas M. Van Horn
;; Inspired by: https://github.com/magnars/s.el

;; Author: Nicholas M. Van Horn <vanhorn.nm@gmail.com>
;; Keywords: string scheme chicken
;; Version: 1.0

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA. (or visit http://www.gnu.org/licenses/)
;;

;;; Commentary:

;; These are helper functions for working with strings. Many of these
;; ideas are a direct port of Magnar Sveen's Elisp string library
;; (https://github.com/magnars/s.el). Furthermore, many of these
;; procedures are wrappers around existing functionality meant to
;; provide a unified string system for users.

;;; TODO: Create these procedures: s-word-wrap, s-with,
;;; s-format

(module s *
  
  (import scheme chicken)
  (use irregex data-structures srfi-1 srfi-13)

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
  (define (s-chomp s)
    (s-chop-suffixes '("\n" "\r") s))

;;; s-collapse-whitespace (s)
;;; Convert all adjacent whitespace characters to a single space.
;;; This can be accomplished with the unit regex egg in chicken. I add
;;; this wrapper for convenience
  (define (s-collapse-whitespace s)
    (irregex-replace/all "[[:space:]|\r]+" s " "))

;;; s-word-wrap (len s)
;;; If s is longer than len, wrap the words with newlines.
  ;; (define (s-word-wrap len s)
  ;;   (if (<= (string-length s) len) s
  ;;       ))

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
    (if (> (string-length s) len)
	(let ((tmp (string->list s)))
	  (conc (list->string (take tmp (- len 3))) "..."))
	s))

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
    (string-chomp s suffix))

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
    (irregex-replace (conc "^" prefix) s ""))

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
     (else (conc s (s-repeat (- num 1) s)))))

;;; s-concat (&rest strings)
;;; Join all the string arguments into one string.
  (define s-concat
    (lambda args
      (apply conc args)))

;;; s-prepend (prefix s)
;;; Concatenate prefix and s
  (define (s-prepend prefix s)
    (conc prefix s))

;;; s-append (suffix s)
;;; Concatenate s and suffix
  (define (s-append suffix s)
    (conc s suffix))

;;; s-lines (s)
;;; Splits s into a list of strings on newline characters.
  (define (s-lines s)
    (string-split s "\n\r"))

;;; s-match (regexp s) 
;;; When the given expression matches the string, this function
;;; returns a list of the whole matching string and a string for each
;;; matched subexpression. If it did not match the returned value is
;;; an empty list (nil).
  (define (s-match regexp s)
    (let ((result (irregex-search regexp s)))
      (if result
	  (let ((num-matches (irregex-match-num-submatches result)))
	    (define (list-matches mymatches idx)
	      (if (> idx num-matches) '()
		  (cons (irregex-match-substring mymatches idx)
			(list-matches mymatches (+ idx 1)))))
	    (list-matches result 0))
	  '())))

  ;; (define (s-match regexp s)
  ;;   (let ((result (string-search regexp s)))
  ;;     (if result result '())))

;;; s-match-multiple (regexp s)
;;; Returns a list of all matches to regexp in s.
;;; This procedure was greatly simplified using irregex
(define (s-match-multiple regexp s)
  (irregex-extract regexp s))

;; (define (s-match-multiple regexp s)
;;   (let ((myregexp (s-append ")(.*)" (s-prepend "(" regexp))))
;;     (let ((mymatch (s-match myregexp s)))
;;       (if (null? mymatch) '()
;; 	  (cons (cadr mymatch) 
;; 		(s-match-multiple regexp (car (cddr mymatch))))))))

;;; s-split (separators s #!optional keepempty)
;;; Splits `s` into substrings bounded by matches for SEPARATORS. If
;;; KEEPEMPTY is #t, zero-length substrings are returned. 
(define (s-split separators s #!optional keepempty)
  (string-split s separators keepempty))

;;; s-join (separator strings)
;;; Join all the strings in strings with separator in between
  (define (s-join separator strings)
    (string-join strings separator))

;;; s-chop (s len)
;;; Return a list of substrings taken by chopping {{s}} every {{len}}
;;; characters. 
(define (s-chop len s)
  (string-chop s len))

;;; s-equals? (s1 s2)
;;; Is s1 equal to s2?. This is simple wrapper around the built-in
;;; string= 
  (define (s-equals? s1 s2)
    (string= s1 s2))

;;; s-matches? (regexp s)
;;; Does regexp match s?
  (define (s-matches? regexp s)
    (irregex-match-data? (irregex-match regexp s)))

;;; n-blank? (s)
;;; Is s null (an empty string)?
  (define (s-blank? s)
    (string-null? s))

;;; s-ends-with? (suffix s #!optional ignore-case)
;;; Does s end with suffix? If ignore-case is #t, case comparison is
;;; ignored. 
  (define (s-ends-with? suffix s #!optional (ignore-case #f))
    (if ignore-case
	(s-starts-with? (s-reverse suffix) (s-reverse s) #t)
	(s-starts-with? (s-reverse suffix) (s-reverse s))))


  ;; (define (s-ends-with? suffix s #!optional (ignore-case #f))
  ;;   (if ignore-case
  ;; 	(string-suffix-ci? suffix s)
  ;; 	(string-suffix? suffix s)))

;;; s-starts-with? (prefix s #!optional ignore-case)
;;; Does s start with suffix? If ignore-case is #t, case comparison is
;;; ignored. 
  (define (s-starts-with? prefix s #!optional (ignore-case #f))
    (if ignore-case
	(let ((mymatch (substring-index-ci prefix s)))
	  (if (and mymatch (= mymatch 0)) #t #f))
	(let ((mymatch (substring-index prefix s)))
	  (if (and mymatch (= mymatch 0)) #t #f))))

;;; s-contains? (needle s #!optional ignore-case)
;;; Does s contain needle?. If ignore-case is #t, case comparison is
;;; ignored. 
  (define (s-contains? needle s #!optional (ignore-case #f))
    (cond
     (ignore-case
      (if (string-contains-ci s needle)
	  #t
	  #f))
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
    (if (and (irregex-match ".*[a-z]+.*" s) 
	     (irregex-match ".*[A-Z]+.*" s))
	#t
	#f))

;;; s-capitalized? (s)
;;; In s, is the first letter upper case, and all other letters lower
;;; case? 
  (define (s-capitalized? s)
    (s-equals? s (s-capitalize s)))

;;; s-titleized? (s)
;;; In s, is the first letter of each word upper case, and all other
;;; letters lower case?
  (define (s-titleized? s)
    (s-equals? s (s-titleize s)))

;;; s-numeric? (s)
;;; Is s a number?
  (define (s-numeric? s)
    (if (irregex-match "[0-9]+" s) #t #f))

;;; s-replace (old new s)
;;; Replaces old with new in s (old is NOT a regexp)
  (define (s-replace old new s)
    (irregex-replace/all (irregex-quote old) s new))

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
  (define (s-split-words s)
    (irregex-extract 
     "\\w+"
     (irregex-replace/all "_+" (irregex-replace/all
				"(?<!^)(?=[A-Z])" s " ") " ")))

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

;;; s-unique-words (s)
;;; Return list of unique words in s.
(define (s-unique-words s)
  (let ((mywords (s-split-words s)))
    (define (unique mylist)
      (cond
       ((null? mylist) '())
       ((member (car mylist) (cdr mylist)) (unique (cdr mylist)))
       (else (cons (car mylist) (unique (cdr mylist))))))
    (unique mywords)))

)
;;; s.scm ends here.
