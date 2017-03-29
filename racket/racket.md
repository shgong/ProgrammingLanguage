
# Racket

### From ML to Racket

- vs ML
  + racket does not use static type system
  + racket has very minimalist and uniform syntax
- vs Scheme
  + LISP 1958 => Scheme 1975 => Racket 2010


#### Can recursion with anonoymous functions

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
```
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
