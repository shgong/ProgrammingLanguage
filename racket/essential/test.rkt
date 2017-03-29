#! /usr/bin/env racket
#lang racket

(define (bad-letrec x)
  (letrec (
    [z 13])
    (if x y z)))