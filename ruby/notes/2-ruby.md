# Ruby 2

## 1. OOP Versus Functional Decomposition

- implementation operations for a small expression language
  - functional: break programs down into functions
  - OOP: break programs down into classes with certain behavior

- they largely lay out the same ideas, in exactly opposite ways
- which way is better is
  - either a matter of taste
  - or depends on how software might be changed or extended in the future

### The Basic Set-Up

- arithmetic language
  - variants of expression: integer, negation, addition
  - operation over expression: eval, toString, hasZero
- lead to
  - a conceptual matrix 3x3
  - whatever language you choose, you need to fill the grids

### Functional Approach

- Steps
  - Define a datatype for expression, with one constructor for each variant
  - Define a function for each operation
  - For each function, have a branch (e.g. pattern match) for each variant of data
    - if there is a default for many variants, use wildcard pattern to avoid enunmeration
- Procedural decomposition
  - breaking problem down into procedures corresponding to each operation

```ml
exception BadResult of string

datatype exp =
  Int    of int
| Negate of exp
| Add    of exp * exp

fun eval e =
  case e of
      Int _ => e
    | Negate e1 => (case eval e1 of
                      Int i => Int (~i)
                        | _ => raise BadResult "non-int in negation")
    | Add(e1,e2) => (case (eval e1, eval e2) of
                        (Int i, Int j) => Int (i+j)
                        | _ => raise BadResult "non-ints in addition")
fun toString e =
  case e of
    Int i => Int.toString i
  | Negate e1 => "-(" ^ (toString e1) ^ ")"
  | Add(e1,e2) => "(" ^ (toString e1) ^ " + " ^ (toString e2) ^ ")"

fun hasZero e =
  case e of
    Int i => i=0
  | Negate e1 => hasZero e1
  | Add(e1,e2) => (hasZero e1) orelse (hasZero e2)
```


### The OO Aproach

- Steps
  - Define a class for expression, with one abstract method for each operation
  - Define a subclass for each variant of data
  - For each subclass, have a method definition for each oepration
    - if there is a default for many variants, use a method in superclass to avoid enunmeration
- Data-oriented decomposition
  - breaking problem down into classes corresponding to each variant


```ruby


```




## 2. Extending Code with New Operations or Variants
## 3. Binary Methods with Functional Decomposition
## 4. Binary Methods in OOP: Double Dispatch
## 5. Multimethods
## 6. Multiple Inheritance
## 7. Mixins
## 8. Java/C# Style Interface
## 9. Abstract Methods
