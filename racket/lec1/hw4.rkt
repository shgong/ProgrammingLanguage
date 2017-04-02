
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below
(define (sequence low high stride)
    (if (<= low high)
        (cons low
              (sequence (+ low stride)
                        high
                        stride))
        null))
    
(define (string-append-map xs suffix)
  (map (lambda (x)
         (string-append x
                        suffix))
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
      (let ([ans (s)])
        (cons (car ans)
              (stream-for-n-steps (cdr ans)
                                  (- n 1))))
      null))

(define funny-number-stream
  (letrec ([f (lambda(n) 
                  (cons (if ( = (remainder n 5)0) (- n) n)
                        (lambda () (f (+ n 1)))))])
  (lambda () (f 1))))
      
(define (dan-then-dog)
  (define dan (lambda() (cons "dan.jpg" dog)))
  (define dog (lambda() (cons "dog.jpg" dan)))
  (dan))

(define (stream-add-zero s)
  (lambda () (let ([t (s)])
               (cons (cons 0 (car t))
                     (stream-add-zero (cdr t)))
                     )))

(define (cycle-lists xs ys)
   (letrec ([f (lambda(n) 
                  (cons (cons (list-nth-mod xs n)
                              (list-nth-mod ys n))
                        (lambda () (f (+ n 1)))))])
   (lambda () (f 0))))

(define (vector-assoc v vec)
  (define (handle n)
    (if (>= n (vector-length vec))
        #f
        (let ([vt (vector-ref vec n)])
          (if (and (pair? vt)
                   (= v (car vt)))
              vt
              (handle (+ n 1))))))
  (handle 0))


(define (cached-assoc xs n)
  (letrec ([cache (make-vector n #f)]
           [cacheid 0]
           [f (lambda (v)
                (let ([res (vector-assoc v cache)])
                  (if res
                      (cdr res)
                      (let ([cp  (assoc v xs)])
                        (vector-set! cache cacheid cp)
                        (set! cacheid (+ cacheid 1))
                        cp))))])
    f))

