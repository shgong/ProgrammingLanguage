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
  - can hold objects from different classes
  - negative array indices from end of the array
  - no array bounds error, return nil
  - many methods in std lib
- also act as structs
  - tuple
  - stacks (push, pop)
  - queues (push, shift)


```ruby
a = [e1, e2, e3, e4]  #sindex 0 1 2 3
a[0]    # get
a[1]=2  # set

Array.new(4)      #[nil,nil,nil,nil]
Array.new(x){0}   #[0,0,0...0]
Array.new(5){|i| -i}  #[0,-1,-2,-3,-4]
```


## Passing Blocks

Ruby has while loop and for loops, but not much people use them

```ruby
# print hi x times
x.times {puts "hi"}

y = 7
[4,6,8].each { y+=1 }  # y = 10

sum = 0
[4,6,8].each { |x| sum += x} # sum = 18

# inject is like fold
sum = [4,6,8].inject(0){|acc,elt| acc+elt }
```

define your own method that take blocks
```ruby
def foo x
  if x
    yield
  else
    yield
    yield
  end
end

foo (true) { puts "hi" }
foo (false) { puts "hi" }
```

put argument after yield to pass argument to block
```ruby
def count i
  if yield i
    1
  else
    1 + (count(i+1) {|x| yield x})
  end
end
```

## Proc

- Blocks are not quite closure, because they are not objects
- cannot store in field, pass as method argument, assign to varaible, put in array
- the real closures in Ruby is Proc

```ruby
a = [3,5,7,9]
b = a.map{|x| x+1}        # [4,6,8,10]
i = b.count{|x| x>=6}     # 3

# proc
c = a.map {|x| lambda {|y| x>=y}}
c[2].call 17                # false: 7 >= 17
j = c.count {|x| x.call(5)} # 3    3>=5,5>=5,7>=5,9>=5
```

Ruby's design is an interesting contrast from ML and Racket, which just provide full closures as the natural
choice. In Ruby, blocks are more convenient to use than Proc objects and suce in most uses, but program-
mers still have Proc objects when needed. Is it better to distinguish blocks from closures and make the more
common case easier with a less powerful construct, or is it better just to have one general fully powerful
feature? (Or just fully powerful and add some syntactic sugars)

## Hashes and Ranges

- hash is like a object to object map

```ruby
# common (more efficient) to use ruby's symbol
{"SML"=>7, "Racket"=>12, "Ruby"=>42}
{:sml=>7, :racket=>12, :ruby=>42}
h["a"] = "foundA"
h[false] = "foundFalse"
h[false]
h[42]

h.keys
h.values
h.delete(key)
```

- range is contiguous sequence of numbers
  - Array.new(100) {|i| i}
  - 1..100
- duck typing let us use array methods

```ruby
def foo a
  a.count {|x| x*x<50}
end

foo (2..10)
```

## Subclass and inheritance

- a ruby class definition specifies super class `C < D`, default `D < Object`
- use built-in reflection to explore class hierarchy
- every object has method `is_a?` (support subclass) and `instance_of?` (only same)

```ruby
class Point
  attr_accessor :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end
  def distFromOrigin
    Math.sqrt(@x * @x + @y * @y)  # use variable directly
  end
  def distFromOrigin2
    Math.sqrt(x*x + y*y)          # use getter method
  end
end

class ColorPoint < Point
  attr_accessor :color
  def initialize(x,y,c="clear")
    super(x,y) # allow overriding method to call method of the same name in superclass first
    @color = c
  end
end

class ThreeDPoint < Point
  attr_accessor :z
  def initialize(x,y,z)
    super(x,y)
    @z = z
  end
  def distFromOrigin
    d = super
    Math.sqrt(d*d + @z * @z)
  end
  def distFromOrigin2
    d = super
    Math.sqrt(d*d + z*z)
  end
end


class PolarPoint < Point
  def initialize(r,theta)
    @r = r
    @theta = theta
  end
  def x
    @r * Math.cos(@theta)
  end
  def y
    @r * Math.sin(@theta)
  end

  def x= a
    b = y # avoids multiple calls to y method
    @theta = Math.atan(b / a)
    @r = Math.sqrt(a*a + b*b)
    self
  end

  def y= b
    a = y # avoid multiple calls to y method
    @theta = Math.atan(b / a)
    @r = Math.sqrt(a*a + b*b)
    self
  end

  def distFromOrigin
    @r
  end
  # distFromOrigin2 already works!!
end
```

## The Precise Definition of Method Lookup
- given a call `e0.m(e1,e2..en)`
  - what are rules to look up what method definition `m` we call
  - non-trivial question in presence of overriding
- in ruby
  - local variables: not too different from ML & Racket
  - instance variable, class variable and methods => different
    - depend on the object bound to `self`
