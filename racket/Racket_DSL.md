
# Racket Lists

```racket
; helper functions for constructing
(define (Const i) (list ’Const i))
(define (Negate e) (list ’Negate e))
(define (Add e1 e2) (list ’Add e1 e2))
(define (Multiply e1 e2) (list ’Multiply e1 e2))
; helper functions for testing
(define (Const? x) (eq? (car x) ’Const))
(define (Negate? x) (eq? (car x) ’Negate))
(define (Add? x) (eq? (car x) ’Add))
(define (Multiply? x) (eq? (car x) ’Multiply))
; helper functions for accessing
(define (Const-int e) (car (cdr e)))
(define (Negate-e e) (car (cdr e)))
(define (Add-e1 e) (car (cdr e)))
(define (Add-e2 e) (car (cdr (cdr e))))
(define (Multiply-e1 e) (car (cdr e)))
(define (Multiply-e2 e) (car (cdr (cdr e))))
```

- Symbols
  - like String
  - compare between sybols are faster than strings
  - can use eq?, but not for strings (copys)

- construct a list with symbol and content
- check list elements

```
(define (eval-exp e)
  (cond [(Const? e) e] ; note returning an exp, not a number
        [(Negate? e) (Const (- (Const-int (eval-exp (Negate-e e)))))]
        [(Add? e) (let ([v1 (Const-int (eval-exp (Add-e1 e)))]
                        [v2 (Const-int (eval-exp (Add-e2 e)))])
                  (Const (+ v1 v2)))]
        [(Multiply? e) (let ([v1 (Const-int (eval-exp (Multiply-e1 e)))]
                             [v2 (Const-int (eval-exp (Multiply-e2 e)))])
                       (Const (* v1 v2)))]
        [#t (error "eval-exp expected an exp")]))

```

# Racket Struct

```
(struct foo (bar baz quux) #:transparent)
```

- look like ML constructor
- it adds to environment functions for constructing foo
  + foo
  + foo?
  + foo-bar
  + foo-baz
  + foo-quux
- attributes
  + `#:transparent` makes the fields and accessor functions visible outside the module
    * e.g. `(foo "hi" (+ 3 7) #f)` will print as
      + `#<foo>` if not transprent
      + `(foo "hi" 10 #f)` if transprent
  + `#: mutable` attr make all fields mutable by providing
    * `set-foo-bar!`, `set-foo-baz!`, `set-foo-quux!`



```racket
(struct const (int) #:transparent)
(struct negate (e) #:transparent)
(struct add (e1 e2) #:transparent)
(struct multiply (e1 e2) #:transparent)

(define (eval-exp e)
  (cond [(const? e) e] ; note returning an exp, not a number
        [(negate? e) (const (- (const-int (eval-exp (negate-e e)))))]
        [(add? e) (let ([v1 (const-int (eval-exp (add-e1 e)))]
                        [v2 (const-int (eval-exp (add-e2 e)))])
                      (const (+ v1 v2)))]
        [(multiply? e) (let ([v1 (const-int (eval-exp (multiply-e1 e)))]
                             [v2 (const-int (eval-exp (multiply-e2 e)))])
                          (const (* v1 v2)))]
        [#t (error "eval-exp expected an exp")]))

```

# Why struct is better
