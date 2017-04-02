
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below
(define (sequence low high stride)
    (if (< low high)
        (cons low
              (sequence (+ low stride)
                        high
                        stride))
        null))
    
(define (string-append-map xs suffix)
  (map (lambda (x)
         (string-append suffix
                        x))
       xs))

(define (list-nth-mod xs n)
  (cond [(< n 0)
         (error "list-nth-mod: negative number")]
        [(empty? xs)
         (error "list-nth-mod: empty list")]
        [#t (let ([r (remainder n (length xs))])
              (list-ref xs r))]))
        
(define (stream-for-n-steps s n)
  (if (> n 0)
      (cons (car s)
            (stream-for-n-steps (cdr s)
                                (- n 1)))
      null))

(define funny-number-stream
  (letrec ([f (lambda(n) 
                  (cons (if ( = (remainder n 5)0) (- 0 n) n)
                        (lambda () (f (+ n 1)))))])
  (lambda () (f 1))))
      
(define (dan-then-dog)
  (define dan (lambda() (cons "dan.jpg" dog)))
  (define dog (lambda() (cons "dog.jpg" dan)))
  (dan))


