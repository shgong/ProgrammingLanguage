#! /usr/bin/env racket
#lang racket

;cons when second element non-empty
(cons 1 2)
(cons "banana" "split")

(pair? (cons 1 2))
(pair? (list 1 2 3))

(car (cons 1 2))
(cdr (cons 1 2))

(car (list 1 2 3))
(cdr (list 1 2 3))

(cons (list 2 3) 1)
(cons 1 (list 2 3))

(cons 0 (cons 1 2))



;quote form
'((1)(2 3)(4))

(string->symbol "map")

(+ 1 . (2))
(list 1 . (2 3))
(car (list 1 . (2 3)))

(+ 1 2)

(1 . + . 2)
(1 . < . 2)

(car ''road)

