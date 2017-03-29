#! /usr/bin/env racket
#lang racket

(define (converse s)
  (define (starts? s2) ; local to converse
    (define len2 (string-length s2))  ; local to starts?
    (and (>= (string-length s) len2)
         (equal? s2 (substring s 0 len2))))
  (cond
   [(starts? "hello") "hi!"]
   [(starts? "goodbye") "bye!"]
   [else "huh?"]))
 

(define (twice f v)
  (f (f v)))

(twice (lambda (s) (string-append s "!"))
         "hello")

(let* ([x (random 4)]
         [o (random 4)]
         [diff (number->string (abs (- x o)))])
    (cond
     [(> x o) (string-append "X wins by " diff)]
     [(> o x) (string-append "O wins by " diff)]
     [else "cat's game"]))
