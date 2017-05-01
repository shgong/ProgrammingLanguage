# Static Typing

-----

## ML vs Racket

- similar in many ways
    - constructs that encourage a functional style
    - allow mutation where appropriate
- differences
    - very different approaches to syntax
    - ML pattern matching vs Racket accessor function for structs
    - Racket multiple variants of let expressions (letrec, let*)
    - Biggest difference: ML has static type system
        - ML rejects lots of programs before running by doing type-checking and reporting errors
        - as a result, ensure absence of certain errors at compile time


#### How a Racket programmer might view ML
  - ML is roughly subset of Racket, reject many not part of the language
  - mostly program with potential bugs
  - but sometimes valid program like `(list 1 #t "hi")`, ML cannot type-check the usage of list elements


#### How a ML programmer might view Racket
- Racket is a superset of ML
- OR: Racket is just ML where every expression is part of one big datatype
  - all results is implicitly wrapped by a contructor into bigger type
  - and all operators will check tags of arguments and raise error

```sml
datatype theType = Int of int
                 | String of string
                 | Pair of theType * theType
                 | Fun of theType -> theType
                 | ... (* one constructor per built in type *)

fun car v = case v of Pair(a,b) => a
                    | _ => raise Error

fun car v = case v of Pair _ => true
                    | _ => false
```

- The fact that we can think of Racket in terms of theType suggests:
  - anything in Racket can be done, perhaps more awkwardly, in ML


-----

## Static checking

- Procedure: reject program after it parses, before it runs
- common way to define: via a type system
- Trade-off
  - run time checking or compile time checking
  - Racket can tag each value, but ML don't have

#### Correctness: Soundness, Completeness, Undecidability

- e.g. we wish to prevent X
- we call a type system is:
  - sound, if never accept program that may does X
  - complete, if never rejects a program that will never do X  
  - soundness prevents false negatives
  - completeness prevents false positives
- type systems are sound
  - so we are sure X never happens
- type systems are not complete
- it is impossible to implement a static checker that
    - always terminate
    - is sound
    - is complete
- since we have to give up one, complete seems an good option

#### theory of computation

- Undecidability, at the heart of study of computation theory
- it directly implies the inherent approximation (i.e., incompleteness) of static checking is probably the most important ramification of undecidability
- we cannot write a program that always correctly predict another program
  - will this program divide by zero
  - will this program treat a string as a function
  - will this program terminate

#### Weak Typing

- suppose a type system unsound for X
  - to be safe, language should still perform dynamic checks at run time
  - Weakly typed: if allow legal implementation to set computer on fire
  - Strongly typed: more limited
- Example
  - C/C++ are well-known weakly typed language
  - designers don't want definition to force implementation to do all dynamic checks
    - a time cost to perform
    - has to keep extra data tags, while C/C++ are designed as lower-level languages

#### More flexible primitives is related but different issue

- Another way is change illegal definition to report less error
- which looks more dynamic
  - allow out of bound arrays, by return some default value or e
  - allow function call with wrong number of argument, by ignore or default
- it mask errors and mask them more difficult to debug

----

## Advantages and Disadvantages of Static checking

#### 1. Convenience

- Argument: Dynamic Typing is more convenient
  - mix-and-match different data types without declare new definitions

```racket
(define (f y) (if (> y 0) (+ y y) "hi"))
(let ([ans (f x)]) (if (number? ans) (number->string ans) ans))
```

```sml
datatype t = Int of int | String of string
fun f y = if y > 0 then Int(y+y) else String "hi"
val _ = case f x of Int i => Int.toString i | String s => s
```

- However, static typing is more convenient to assume data has a certain type
  - dynamic language need an explicit dynamic check

```racket
(define (cube x)
  (if (not (number? x))
    (error "cube expects a number")
    (* x x x)))
(cube 7)
```

```sml
fun cube x = x * x * x
val _ = cube 7
```

#### 2. Prevent Useful Programs

In ML, construct a pair of pairs from different types need us to work around type system. We have to use a datatype to represent `The One Racket Type`, and insert explicit tags and pattern matching everywhere.


#### 3. Early Bug-Detection

- Argument: Static typing catches bugs earlier
  - Well-known truism: bugs are easier to fix if discovered sooner

```racket
(define (pow x)
  (lambda (y)
    (if (= y 0)
      1
      (* x (pow x (- y 1))))))
```

```sml
fun pow x y = (* does not type-check *)
  if y = 0
  then 1
  else x * pow (x,y-1)
```

- Pow expect curried arguments, while we call two arguments
  - racket version need a run to discover
  - ml just don't type check

- Argument: you would catch the same error with testing anyway
  - type check won't find arithmetic error

#### 4. Performance

- Argument: Static typing can lead to faster code
  - not storing the type tag
  - dynamic typing takes more space and slow down constructors
- Counters
  - low-level performance does not matter in most software
  - implementations can try optimize away unnecessary tests
  - static typing workarounds like dataType also erode performance advantage

#### 5. Code Reuse

- Argument: dynamic typing is easier to reuse library functions. Avoid getter, setter by using shared method like car, cdr
- Counter: this can mask bugs, when you car from a tree instead of list, and still get some looklike-valid result


#### 6. Better for Prototyping

- Dynamic typing often considered better for prototyping
  - can run part of program even other part unimplemented
- Counter
  - it is never too early to document the types
  - commenting out or adding pattern match branch


#### 7. Better for Coding Evolution?

- maintaining working programs
  - fixing bugs
  - adding new features
  - evolving the code
- dynamic typing is sometimes more convenient
  - change code to be more permissive without changing existing clients
  - while static typed language need wrap constructors and use pattern match
- static typing easier to catch bugs that evolution may introduce

```racket
(define (f x) (* 2 x))

(define (f x)
  (if (number? x)
      (* 2 x)
      (string-append x x)))
```



------
## eval and quote

Racket is an interpreted language: it has a primitive eval that can take a representation of a program at run-time and evaluate it.

```
(define (make-some-code y)
  (if y
    (list 'begin (list 'print "hi") (list '+ 4 2))
    (list '+ 5 3)))

(define (f x)
  (eval (make-some-code x)))
```

- Many languages have eval, many do not.
- Can a compiler-based language implementation deal with eval?
  - it would need to have the compiler or an interpreter around at run-time
  - while the interpreter-based language already have that to evaluate

- in racket, it is unnecessary to write make-some-code like we did
- there is a special form quote that treat everything under as symbols
- for any e, can be written as `(eval (quote e))`
- string interpolation is just quasiquoting

```racket
(define (make-some-code y)
  (if y
    (quote (begin (print "hi") (+ 4 2)))
    (quote (+ 5 3))))
```
