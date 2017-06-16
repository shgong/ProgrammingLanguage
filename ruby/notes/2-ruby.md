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
class Exp
  # could put default implementations or helper methods here
end

class Int < Exp
  attr_reader :i
  def initialize i
    @i = i
  end

  def eval
    self
  end

  def toString
    @i.to_s
  end

  def hasZero
    i==0
  end
end

class Negate < Exp
  attr_reader :e
  def initialize e
    @e = e
  end

  def eval
    Int.new(-e.eval.i) # error if e.eval has no i method (not an Int)
  end

  def toString
    "-(" + e.toString + ")"
  end

  def hasZero
    e.hasZero
  end
end

class Add < Exp
  attr_reader :e1, :e2

  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end

  def eval
    Int.new(e1.eval.i + e2.eval.i) # error if e1.eval or e2.eval have no i method
  end

  def toString
    "(" + e1.toString + " + " + e2.toString + ")"
  end

  def hasZero
    e1.hasZero || e2.hasZero
  end
end
```


### The Punch-Line

- Just deciding whether to layout our program by column or by row
- understanding this symmetry is invaluable
  - in conceptualizing software
  - or deciding how to decompose a problem


- which is better
  - for our expression problem, functional is popular
    - more natural to have cases to `eval` together
    - instead of for `Negate` together
  - for GUI development, OOP is popular
    - more natural to have `MenuBar` together
    - instead of for `doIfMouseIsClicked` togather


## 2. Extending Code with New Operations or Variants

```
fun noNegConstants e =
  case e of
    Int i => if i < 0 then Negate (Int(~i)) else e
    | Negate e1 => Negate(noNegConstants e1)
    | Add(e1,e2) => Add(noNegConstants e1, noNegConstants e2)
```

- Considering the functional approach
  - add a method is easy
  - add new data variant is less pleasant
- While the OO Approach opposite

```ruby
class Mult < Exp
  attr_reader :e1, :e2
  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end

  def eval
    Int.new(e1.eval.i * e2.eval.i) # error if e1.eval or e2.eval has no i method
  end

  def toString
    "(" + e1.toString + " * " + e2.toString + ")"
  end

  def hasZero
    e1.hasZero || e2.hasZero
  end
end
```

### Planning for extensibility

- For OOP, Visitor pattern is a common approach
  - implemented with double dispatch
- For functional
  - define data type to have other possibilities

```sml
datatype ’a ext_exp =
    Int    of int
  | Negate of ’a ext_exp
  | Add    of ’a ext_exp * ’a ext_exp
  | OtherExtExp  of ’a

fun eval_ext (f,e) = (* pass a function to handle extensions *)
  case e of
    Int i =>i
    | Negate e1 => 0 - (eval_ext (f,e1))
    | Add(e1,e2) => (eval_ext (f,e1)) + (eval_ext (f,e2))
    | OtherExtExp e => f e
```

Notes: it does not work to wrap original datatype
  - does not allow subexpression of `Add` to be `MyMult`
```ml
datatype myexp_wrong =
    OldExp of exp
  | MyMult of myexp_wrong * myexp_wrong
```


### Problems about extensibility

- the future is often difficult to predict
  - both forms of extension may be likely
  - new language like Scala aim to support both extension well
- making software both robust and extensible is valuable
  - but difficult
  - extensibility require original code
    - more work to develop
    - harder to reason about locally
    - harder to change without break extensions
- language often provide constructs to prevent extensibility
  - ML's module can hide datatypes
  - Java final modifier prevent subclasses

## 3. Binary Methods with Functional Decomposition

- When we have operations take 2+ variants
  - can apply functional Decomposition
  - while OOP approach is more cumbersome

```ml
fun eval e =
   case e of
      ...
     | Add(e1,e2)  => add_values (eval e1, eval e2)
...
fun add_values (v1,v2) =
    case (v1,v2) of
        (Int i,  Int j)         => Int (i+j)
      | (Int i,  String s)      => String(Int.toString i ^ s)
      | (Int i,  Rational(j,k)) => Rational(i*k+j,k)
      | (String s,  Int i)      => String(s ^ Int.toString i) (* not commutative *)
      | (String s1, String s2)  => String(s1 ^ s2)
      | (String s,  Rational(i,j)) => String(s ^ Int.toString i ^ "/" ^ Int.toString j)
      | (Rational _,    Int _)    => add_values(v2,v1) (* commutative: avoid duplication *)
      | (Rational(i,j), String s) => String(Int.toString i ^ "/" ^ Int.toString j ^ s)
      | (Rational(a,b), Rational(c,d)) => Rational(a*d+b*c,b*d)
      | _ => raise BadResult "non-values passed to add_values"
```

- if many case works the same way, apply wildcard patterns

## 4. Binary Methods in OOP: Double Dispatch

- Try to support the same enhancement for `Add` in an OOP style
- in Add, we write

```ruby
def eval
  e1.eval.add_values e2.eval
end
```

#### Dispatch

- obligate us to have add_values methods in classes
- in each class, define

```ruby
class Int
  ...
  def add_values v
    if v.is_a? Int
      ...
    elsif v.is_a? MyRational
      ...
    else
      ...
    end
  end
end
```

- it is not really OOP
  - it is a mix of object-oriented decomposition
    - dynamic dispatch on the first argument
  - functional decomposition
    - using is_a? to figure out case in each method
    - simpler to understand probably
    - give up extensibility advantages of OOP
    - NOT "full" OOP

#### Double Dispatch
```ruby
class Int
  ... # other methods not related to add_values

  def add_values v # first dispatch
    v.addInt self
  end

  def addInt v # second dispatch: v is Int
    Int.new(v.i + i)
  end

  def addString v # second dispatch: v is MyString
    MyString.new(v.s + i.to_s)
  end

  def addRational v # second dispatch: v is MyRational
    MyRational.new(v.i+v.j*i,v.j)
  end
end
```

- We have 9 case for addition in 9 different methods
- It is not intuitive
- It is what Ruby/Java must do to support binary operations in OOP style

## 5. Multimethods

- Not all OOP language require that cumbersome double-dispatch pattern
  - language with multimethod or multiple dispatch provide more intuitive solution
- This is a powerful and different semantics
  - what we studied
    - the method lookup rules involves the runtime class of receiver
    - not runtime class of arguments
  - multiple dispatch
    - consider class of multiple objects
- In languages
  - Ruby does not support, becasue Ruby method name is unique
  - Java/C++ has multiple methods with same name
    - but use types of arguments that dtermined at compile time
    - which is called static overloading
  - C# has same static overlaoding
    - v4.0 can use type dynamic to achieve multimethods
  - __Clojure__ has multimethods

## 6. Multiple Inheritance
- Above discussion based on one superclass
- what if multiple?
  - Multiple Inheritance
    - most powerful option
    - have semantic problems that arise
    - C++
  - Mixins
    - just a pile of methods, many semantic problem go away
    - elegant uses of mixins typically involve mixin methods calling assumption methods
    - Ruby
  - Interfaces
    - do not provide behavior, only require method existing
    - fundementally about type checking
    - Java/C#
- multiple changes class hierarchy from tree to graph
- issue with multiple inheritance
  - need fairly complicated rules for how
    - subclassing
    - method lookup
    - field access
  - works
  - C++ have two different forms of creating subclass
    - one makes copies of all fields from all superclasses
    - the otehr makes only one copy of fields from same common ancestor


## 7. Mixins

- To define a Ruby mixin, we use `modeule` instead of `class`
- Following mixin defines three methods
  - color
  - color=
  - darken
- class definition can include module later

```ruby
module Color
  attr_accessor :color
  def darken
    self.color = "dark " + self.color
  end
end

class ColorPt < Pt
  include Color
end
```

- initialize (from Pt) does not create @color field
  - rely on client to call `color=` or first call will get `nil`
- mixins that use instance variables are stylistically questionable
  - will be part of object including it
  - if name conflict, might mutate the same data
  - after all, mixin is simple, jsut define collection of methods

Method Lookup Rules

- send message m to obj from class C
- class C
- mixins in C
- C's superclass
- C's superclass' mixins
- C's super-superclass
- etc

Many elegant uses of mixins do following strange-sounding thing

- define methods that call other methods on self that are not defined by mixin
- mixin assumes that all classes that include mixin define this method

```ruby
module Doubler
  def double
    self + self    # uses self's + message, not defined in Doubler
  end
end

class AnotherPt
  attr_accessor :x, :y
  include Doubler

  def + other # add two points
    ans = AnotherPt.new
    ans.x = self.x + other.x
    ans.y = self.y + other.y
    ans
  end
end

class String
  include Doubler
end
```


- The same idea is used a lot in RUby with two mixins named
  - `Enumerable`
    - many useful block-taking methods that iterate over some data structure
    - like any?, map, count, inject, each
  - `Comparable`
    - provide methods like =, >=, <=
    - assume the class define `<=>`
    - return negative number if left argument less than its right


```ruby
class MyRange
  include Enumerable

  def initialize(low,high)
    @low = low
    @high = high
  end

  def each
    i=@low
    while i <= @high
      yield i
      i=i+1
    end
  end
end

MyRange.new(4,8).inject {|x,y| x+y}
MyRange.new(5,12).count {|i| i.odd?}
```

```ruby
class Name
  attr_accessor :first, :middle, :last
  include Comparable

  def initialize(first,last,middle="")
    @first = first
    @last = last
    @middle = middle
  end

  def <=> other
    l = @last <=> other.last # <=> defined on strings
    return l if l != 0
    f = @first <=> other.first
    return f if f != 0
    @middle <=> other.middle
  end
end
```

## 8. Java/C# Style Interface

- a class can have only one immediate supercalss with number of interfaces
  - interface is list of methods, argument type and return type
  - class typecheck all method provided
- it does not define method
  - nothing about multiple inheritance arise
  - if two interface have conflict, doesn't matter
    - a class can stilil implement them both
- there is no point have interface in dynamically typed language
  - just pass any object to method


## 9. Abstract Methods

- in statically type languages, purpose of type checking is to prevent method missing errors
  - indicate guideline in superclass => abstract class
  - give type of any methods that subclasses must provide => abstract methods
  - in C++, called pure virtual methods

- interesting parallel between abstract method and high-order-functions
  - both cases: some code is passed other code in a flexible and reusable way
  - OOP: different subclasses implment abstract method in different ways
  - OOP: superclass use them via dynamic dispatch
  - HOF: different caller provide different implemnetation in function argument body
