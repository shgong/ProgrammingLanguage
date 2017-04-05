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
