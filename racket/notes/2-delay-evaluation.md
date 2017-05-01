
# Delay Evaluation

- key semantic issue for a language construct: when subexpressions evaluated

- for example: if expresion
  - `(define (my-if-bad x y z) (if x y z))`
  - we don't evaluate y z until it is called
  - would never terminate in a recursion
  - instead
    - `(define (my-if x y z) (if x (y) (z)))`
    - and use `(my-if e1 (lambda () e2) (lambda () e3))`
- there is no point wrap if in this way
- general idiom here is using zero-argument function to delay evaluation
- or thunk the argument
  - `(lambda () e)` instead of `e`


## Lazy Evaluation with Delay and Force

- use mutation to remember the result from first time we use
- when used and not evaluated, update with new value

```
(define (my-delay f)
  (mcons #f f))

(define (my-force th)
   (if (mcar th)
       (mcdr th)
       (begin (set-mcar! th #t)
              (set-mcdr! th ((mcdr th)))
              (mcdr th))))
```

## Stream

- representing a stream as a thunk
- when called, produce a pair of
  - element
  - a thunk that could produce second till end

```
(define ones (lambda () (cons 1 ones)))

(define nats
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

(define powers-of-two
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))
```

use a high-order function to extract common aspect of Stream
```
(define (stream-maker fn arg)
  (letrec ([f (lambda (x)
                (cons x (lambda () (f (fn x arg)))))])
    (lambda () (f arg))))

(define ones (stream-maker (lambda (x y) 1) 1))
(define nats (stream-maker + 1))
(define powers-of-two (stream-maker * 2))
```


## Macros
- Define your own syntax sugar
- Racket Macro is superior to many better knowns like preprocessor in C/C++
  - How macro systems must handle issues of tokenization, parenthesization and scope
  - How to define macros in Racket
  - How macro definitions should be careful about order & times they are evaluated
  - the key issue: hygiene

### Tokenization, Parenthesization and Scope

more structured and subtle than `find-and-replace`

1. at least understand how a programming language's text broken into tokens
  - e.g. `a-b` is three token in most languages, but one in Racket
2. if macros do or do not understand Parenthesization
  - in C/C++
    - `#define ADD(x,y) x+y` will make `ADD(1,2/3)*4` like `1+2/3*4`
    - that's why macro writers generally include lots of explicit parentheses
    - `#define ADD(x,y) ((x)+(y))`
  - in Racket
    - macro expansion preserves code structure
    - always stay in the same parentheses
    - that's benefit of Racket's minimal & consistent syntax
3. if macro expansion happens even when creating variable bindings, will local variable shadow macros?
  - `(let  ([hd 0] [car 1]) hd); 0`
  - `(let* ([hd 0] [car 1]) hd); 0`
  - if replace car with hd
    - first expression will error
    - second now evaluate to 1

### Defining Macros with define-syntax

```
(define-syntax my-if
  (syntax-rules (then else)
    [(my-if e1 then e2 else e3)
      (if e1 e2 e3)]))
```

- `define-syntax` is special form fro defining a macro
- my-if add `my-if` to environment, thus macro-expanded
- `syntax-rules` is the keyword
- `(then else)` list of keywords for this macro
- then list of pairs how `my-if` might be used in the macro
  - in above example there is only one instance of usage
  - other usage will yield ERROR
  - rewriting happens before any evaluations

another example
```
(define-syntax my-delay
  (syntax-rules ()
    [(my-delay e)
    (mcons #f (lambda () e))]))
```

we should not create macro version of my-force
```
(define-syntax my-force
  (syntax-rules ()
    [(my-force e)
    (if (mcar e)
        (mcdr e)
        (begin (set-mcar! e #t)
               (set-mcdr! e ((mcdr e)))
               (mcdr e)))]))
```

use of this macro will end up evaluation argument e multiple times
when e has side effect may be a disaster

```
(my-force (begin (print "hi") (my-delay some-complicated-expression)))
```

- instead we should add `let([x e])` and use x in macro
- but it still does not make sense, the original plain `my-force` already did what we need

### Variables, Macros and Hygiene

Let's consider a macro doubles its argument

Without macro, we can just write
```
(define (double x)
  (* 2 x))
```

With macro, we can write
```
(define-syntax double1
  (syntax-rules ()
  [(double1 e)
  (* 2 e)]))

(define-syntax double2
  (syntax-rules ()
  [(double2 e)
    (let ([x e]))
    (+ x x)]))
```

- double2 need local variable to avoid evaluate e twice
  + however in less powerful macro language like C/C++
  + local variables in macros are typically avoided
  + because of hygiene

#### example 1

```
(define-syntax double4
  (syntax-rules ()
    [(double4 e)
      (let* ([zero 0]
             [x e])
         (+ x x zero))]))
```

- when you do `(let ([zero 17]) (double4 zero))`, if just syntactic rewriting
```
(let ([zero 17])
  (let* ([zero 0]
         [x zero])
    (+ x x zero)))
```
- will yield this, which evaluate to 0, not 34


#### example 2
```
(let ([+ *])
  (double2 17))

;naive rewritten
(let ([+ *])
  (let ([x 17])
    (+ 17 17)))
```


- due to free variable at macro use ended up in scope of a local variable
- that's why in C/C++, local variables tend to have funny names like `__x_hopefully_no_conflict`
- however in Racket
    + every time a macro is used, all local varaibles are rewritten to be fresh names that don't conflict
    + always check free variables in macro definition, make sure they don't wrongly end up in scope of local variable


#### some useful macros

```
(define-syntax for
  (syntax-rules (to do)
    [(for lo to hi do body)
    (let ([l lo]
          [h hi])
        (letrec ([loop (lambda (it)
                          (if (> it h)
                          #t
                          (begin body (loop (+ it 1)))))])
          (loop l)))]))
```
