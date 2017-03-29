
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
- check: null? cons? => #t/#f

#### Cond

```racket
(cond [(null? xs) 0]
[(number? (car xs)) (+ (car xs) (sum (cdr xs)))]
[#t (+ (sum (car xs)) (sum (cdr xs)))]))
```
