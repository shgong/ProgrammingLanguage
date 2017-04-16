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
- three possible result of evaluating 





# Possible results


