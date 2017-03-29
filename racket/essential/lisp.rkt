#! /usr/bin/env racket
#lang racket

(andmap string? (list "a" "b" "c"))
(ormap number? (list "a" "b" 6))

(map (lambda (s n) (substring s 0 n))
       (list "peanuts" "popcorn" "crackerjack")
       (list 6 3 7))

(foldl (lambda (elem v)
           (+ v (* elem elem)))
         0
         '(1 2 3))

(cons "head" empty)
(cons? empty)

(define (my-length lst)
  ; local function iter:
  (define (iter lst len)
    (cond
     [(empty? lst) len]
     [else (iter (rest lst) (+ len 1))]))
  ; body of my-length calls iter:
  (iter lst 0))

(define (remove-dups l)
  (cond
   [(empty? l) empty]
   [(empty? (rest l)) l]
   [else
    (let ([i (first l)])
      (if (equal? i (first (rest l)))
          (remove-dups (rest l))
          (cons i (remove-dups (rest l)))))]))