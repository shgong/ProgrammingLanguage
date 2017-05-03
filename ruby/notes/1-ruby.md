# Ruby

## Ruby Features

- Focus on OOP, dynamic typing, blocks and mixins
- Interesting Ruby features
  - pure object-oriented: all values are objects (Java has primitives)
  - class-based: every object is instance of class (Javascript isn't class based)
  - has mixins: reasonable compromise between multiple inheritance (C++) and interfaces (Java)
  - dynamic typed: allow calling any function, with runtime check
  - dynamic features: allow instance variable to be added and removed
  - convenient reflection: has method `class` and `method`
  - has blocks and closures: convenient high-order programming
  - scripting language: engineered towards making it easy to write short programs
- As OO language, ruby shares much with SmallTalk, adding some nice addition like mixins
- ruby is a large language
  - why not attitude
  - unlike ML/Racket/Smalltalk adhere strictly to traditional principles
    - define a small language with powerful features to build up
  - Ruby take opposite view
    - there are many ways to write if expression


## Rules of Class-Based OOP

- OOP
  - all values are reference to objects
  - given an object, code communicates with it by calling method
  - each object has its own private state
  - every object is an instance of a class
  - an object's class determine the object's behavior

## Objects, Classes, Methods, Variable

```ruby
class Foo  # className must be capitalized

  @foo = "newValue" # instance variable
  @@bar = "sharedValue" # class variable

  def m1 # can take any arguments
    ... # a method implicitly returns its last expression
  end

  def m2 (x,y,z=0,w="hi") # default
  end
k
  def mn z
  end

  def self.method_name args # define class constants
  end
end

# constructing an object
Foo.new

# class constant, or static methods
Math::PI
```

## Visibility and Getter/Setter

- Instance variables are private to object
  - even other instance of same class can not access
- methods have visibilities
  - public (first method has an implicit public)
  - private
  - protected (same class or subclasses)

```ruby
def foo
  @foo
end

def foo= x
  @foo = x
end

# setter may be not actually a setter
def celsius_temp= x
  @kelvin_temp = x + 273.15
end

# syntax for defining g/s easily
attr_reader :y, :z
attr_accessor :x
```

> as a cute piece of syntactic sugar, when calling a method ends in =, you can have space before =

## Some Syntax, Semantics and Scopings

```ruby
e1 if e2

if e1
  e2
else
  e3
end

if e1 then e2 else e3 end
```

- several forms of conditional expressions
- new line are significant
- condition on any object are true, except false and nil
- `foo=` feels like assignment but is really method call
- self for this in Java/C#/C++
- variable get automatically created by assignment


## Everything is an Object

- `-42` is an instance of `Fixnum`, thus have method like `abs`
- `-42.abs == 42`
- `nil?` method, check nil, like ML's () and Racket's void object
- method can return self, which help nested call `x.foo(14).bar("hi")`
- don't need main method, top level is accessible

## Duck Typing

- Duck typing
  - if it walks like a duck and quacks like a duck, then it's a duck
  - class of an object is not important so long as object can respond to all message expected

```ruby
def mirror_update pt
  pt.x = pt.x * -1
end
```
- first look: take Point class and mirror y-axis
- actually more general
  - just need method: x & x=, may not be getter setter of varaible x
  - even x don't need to be a number, as long as can accept * method with -1
- Pro & cons
  - more reusable, fake duck can still use code
  - difficult to refactor, you don't dare to change x+x to x*2, as implementation might be different


## Arrays

- much more flexible and dynamic, compared to C/C++/Java

```ruby
a = [e1, e2, e3, e4]



```
