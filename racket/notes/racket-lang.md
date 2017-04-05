
# Racket

### From ML to Racket

- vs ML
  + racket does not use static type system
  + racket has very minimalist and uniform syntax
- vs Scheme
  + LISP 1958 => Scheme 1975 => Racket 2010


### Core syntax

- A language of only atom & parentheses
  + make everything a tree
  + like HTML tags

- Dynamic typing
  + don't use static type to reject programs
  + `(lambda () (1 2))` is perfect function that won't run

#### Anonoymous functions

```racket
(define pow
  (lambda (x y)
    (if (= y 0)
    1
    (* x (pow x (- y 1))))))

; syntax sugar form
(define (pow x y)
  (if (= y 0)
    1
    (* x (pow x (- y 1)))))
```

#### Curried function
```racket
(define pow
  (lambda (x)
    (lambda (y)
      (if (= y 0)
        1
        (* x ((pow x) (- y 1)))))))

;curried sugar
(define ((pow x) y)
  (if (= y 0)
      1
      (* x ((pow x) (- y 1)))))
```

#### List

- Empty List: '() or null
- Construct: (cons 2 (cons 3 null))
- Head/tail: car, cdr
  + car: Contents of the Address part of Register number
  + cdr: Contents of the Decrement part of Register number
- check: null? cons? => #t/#f

#### Cond

```racket
(cond [(null? xs) 0]
      [(number? (car xs)) (+ (car xs) (sum (cdr xs)))]
      [#t (+ (sum (car xs)) (sum (cdr xs)))]))
; #t can also use else
```

#### Local bindings

##### Lazy binding

```racket
(define (silly-double x)
  (let ([x (+ x 3)]
        [y (+ x 2)])
     (+ x y -5)))
```

##### Eager Bindings

```racket
(define (silly-double x)
  (let* ([x (+ x 3)]
         [y (+ x 2)])
      (+ x y -8)))
```

##### Recursive bindings
  + allow reference later defined bindings
  + useful for mutual recursion

```racket
(define (triple x)
  (letrec ([y (+ x 2)]
           [f (lambda (z) (+ z y w x))]
           [w (+ x 7)])
      (f -9)))

(define (mod2 x)
  (letrec
    ([even? (lambda (x) (if (zero? x) #t (odd? (- x 1))))]
     [odd? (lambda (x) (if (zero? x) #f (even? (- x 1))))])
  (if (even? x) 0 1)))

; still evaluated in order, will throw ERROR
(define (bad-letrec x)
  (letrec ([y z]
    [z 13])
    (if x y z)))
```

##### Local define

Prefered style over let-expression
```
(define (mod2_b x)
  (define even? (lambda(x) (if (zero? x) #t (odd? (- x 1)))))
  (define odd? (lambda(x) (if (zero? x) #f (even? (- x 1)))))
  (if (even? x) 0 1))
```

#### Mutable
- allow `set!` to mutate binding

```
(define b 3)
(define f (lambda (x) (* 1 (+ x b))))
(define c (+ b 4))    ; c=7
(set! b 5)
(define z (f 4))      ; z=9
(define w c)
```
- mutating top-level
  + top level binding is not mutable default
  + unless a set! is defined for it
  + while in Scheme all bindings are actually mutable


#### Improper List / Pair

- Nested cons cells
  - `(cons (+7 7) #t)` => pair `'(14 . #t)`
  - `(cons 1 (cons 2 (cons 3 4)))` => nested pair `'(1 2 3 . 4)`
- car cdr now just get first part / second part
- pairs are useful way to build an each-of type
