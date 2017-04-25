# Implementing a Programming Language in General

- Why valuable
  - implementing features helps understand semantics of features
  - dispel the idea that things like higher-order functions or objects are magic
  - programming tasks like display a pdf is like interpreter to a language

- main workflow
  - take string holding concrete syntax of a program
  - parser gives error if not syntactically well-formed
  - otherwise produce a tree, AST
  - type-checker use AST to produce error message or not
  - then we have two approaches
    + write interpreter in another language A
      - take programs in B, and produce the answers
    + write translator/compiler in another language A
      - take programs in B, and produce equivalent in A or C

- modern systems
  + Java system compile Java source into portable intermediate format
  + JVM interpret and compile code into hardware
  + hardware have translator convert binary instructions into units
  + hardware itself is a interpreter written in transistor

# Implementing a language inside another Language

- Example: `(negate (add (const 2) (const 2)))`
- In Racket, we directly write abstract-syntax trees
  - so we skipped parser and checker

# Assumptions and Non-assumptions about legal AST

Let's extends our language

```racket
(struct const (int) #:transparent) ; int should hold a number
(struct negate (e1) #:transparent) ; e1 should hold an expression
(struct add (e1 e2) #:transparent) ; e1, e2 should hold expressions
(struct multiply (e1 e2) #:transparent) ; e1, e2 should hold expressions
(struct bool (b) #:transparent) ; b should hold #t or #f
(struct if-then-else (e1 e2 e3) #:transparent) ; e1, e2, e3 should hold expressions
(struct eq-num (e1 e2) #:transparent) ; e1, e2 should hold expression
```

- new features
  - boolean
  - conditionals
  - a construct for comparing numbers and return boolean
<<<<<<< HEAD

- three possible result of evaluating
  - Integer
  - boolean
  - non-existent, run-time error (treat a type as another)

- interpreter should take care of last possibility and give an appropriate error message

```racket
; eval-exp
[(add? e)
 (let ([v1 (eval-exp (add-e1 e))]
       [v2 (eval-exp (add-e2 e))])
   (if (and (const? v1) (const? v2))
       (const (+ (const-int v1) (const-int v2)))
       (error "add applied to non-number")))]
```

# Interpreters for Languages With Variables Need Environments

- what is missing: Variables
  - evaluating requires environment that map variables to values
  - interpreter needs a recursive helper function that takes expression and produce values

- representation of environment is part of interpreter's implementation, not syntax
  - many representation will suffice
  - fancy data structure for fast access are appropriate (HashMap)
  - as example, we use a simple association list holding pairs of strings and values

- use of environment
  - to evaluate a variable expression, looks up name in environment
  - to evaluate subexpression, interpreter pass outer environment to recursive call
  - to evaluate body of let expression, pass env with one more binding

- call recursive helper that takes an environment with program, and a suitable initial env (maybe empty)


## Implementing Closures

- implement a language with functional closures and lexical scope, we should
  - remember env when function was defined, thus replace caller's environment
  - literally create a small data structure called closure
    - includes a (environment, function) pair
    - function is not value, only a closure is

- also need to implement function calls
  - e.g. a call has two expression
    - `e1 e2` in ML
    - `(e1 e2)` in Racket
  - evaluate e1 using current env
  - evaluate e2 using current env
  - evaluate body part of closure using the environment part of closure extended with arguments

- key idea: extend the environment-stored-with-the-closure to evaluate closure function body

## Implmenting Closures Efficiently

- It may seem expensive that we store whole current env in every closure
  1. it's not that expensive when environments are association lists which extends each other
    - we don't copy lists when we make longer lists with cons
  2. we save space by storing only parts of env that function body might possibly use
    - check function body to get free variables
    - precompute free variables of each function before begin evaluation
  3. if target language does not itself have closures
    - function definition still evaluate to closures that have two parts, code and env
    - change all functions to take an extra `environment` argument, and all function call explicitly pass this argument
    - compiler translate all uses of free variable with find right value from env
    - using arrays can helper lookup faster
=======
- three possible result of evaluating 





# Possible results


>>>>>>> 64088adb678ae64ddeb26d2b2f8ed47863356699
