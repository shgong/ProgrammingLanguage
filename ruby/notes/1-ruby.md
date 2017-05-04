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

- General Rule of evaluate a method call
  - e0.m(e1..en)
  - Evaluate e0..en to values, i.e. obj0..objn
  - Get the class `A` of obj0, every object know its class at run-time
  - If m is defined in A
    - call that method
    - or recur with superclass of A
    - if not found, call method_missing method
    - this method in Object will raise an error
  - If method has formal arguments x1..xn
    - map x1 to obj1, etc
    - while evaluating method body, self is bound to obj0

- When body of m calls a method on self
  - we use the class of obj0 class to resolve some method
  - not necessarily the class of method we are executing
  - that's why `PolarPoint`'s `distFromOrigin2` will works


## Dynamic Dispatch Versus Closures

How dynamic dispatch differs from lexical scope we used for function calls:

```ruby
fun even x = if x=0 then true else odd (x-1)
fun odd  x = if x=0 then false else even (x-1)
```
- thus two closure both have the other closure in their environment.
- if we later shadow the even closure with `fun even x = false`
- will not change how odd behave, it still looks up even in its evn
  - it's good that does not break later
  - but if we have better even like `fun even = (x mod 2) = 0`, won't benefit either

In OOP, however, we can use (abuse?) subclassing, overriding and dynamic dispatch

```ruby
class A
  def even x
    if x==0 then true else odd(x-1) end
  end
  def odd x
    if x==0 then false else even(x-1) end
  end
end

class B < A
  def even x
    x % 2 == 0
  end
end
```

This is dynamic disptach, self bound to current env

## Dynamic Dispatch in Racket


- Why do this
  - one language's semantics, however primitive like, can typically be coded up as an idiom in another language
  - a lower-level way to understand how dynamic dispatch works by seeing a implemnetation
- Actually different from Ruby implementation
  - just contain list of fields & methods, not class-based
  - real implemntations more efficient, use arrays/hashtables for fields, association lists for methods

```racket
# object just have fields and methods
(strut obj (fields methods))
```

- fields hold an immutable list of mutable pairs
- define helper functions like getter and setter

```racket
(define (assoc-m v xs)
  (cond [(null? xs) #f]
        [(equal? v (mcar (car xs))) (car xs)]
        [#t (assoc-m v (cdr xs))]))

(define (get obj fld)
  (let ([pr (assoc-m fld (obj-fields obj))])
    (if pr
        (mcdr pr)
        (error "field not found"))))

(define (set obj fld v)
  (let ([pr (assoc-m fld (obj-fields obj))])
    (if pr
        (set-mcdr! pr v)
        (error "field not found"))))
```

- Methods fields will also be association list
- the key to getting dynamic dispatch to work
  - functions will all take an extra explicit argument that is implicit in ruby languages
  - the argument will be "self"
  - Racket helper function will simply pass in the correct object
- Notice the function we use for methods gets passed the while object obj1
- send can take any number of arguments >= 2

```racket
(define (send obj msg . args)
  (let ([pr (assoc-m msg (obj-methods obj))])
    (if pr
        ((cdr pr) obj args)
        (error "method not found" msg))))
```

- Now we can define make-point
  - each of methods takes a first argument, that call self

```racket
  (define (make-point _x _y)
    (obj
      (list (mcons 'x _x)
            (mcons 'y _y))
      (list (cons 'get-x (lambda (self args) (get self 'x)))
            (cons 'get-y (lambda (self args) (get self 'y)))
            (cons 'set-x (lambda (self args) (set self 'x (car args))))
            (cons 'set-y (lambda (self args) (set self 'y (car args))))
            (cons 'distToOrigin
                  (lambda (self args)
                    (let ([a (send self 'get-x)]
                          [b (send self 'get-y)])
                      (sqrt (+ (* a a) (* b b)))))))))

(define p1 (make-point 4 0))
(send p1 'get-x) ; 4
(send p1 'get-y) ; 0
(send p1 'distToOrigin) ; 4
(send p1 'set-y 3)
(send p1 'distToOrigin) ; 5


(define (make-color-point _x _y _c)
  (let ([pt (make-point _x _y)])
    (obj
      (cons (mcons 'color _c)
            (obj-fields pt))
      (append (list
                (cons 'get-color (lambda (self args) (get self 'color)))
                (cons 'set-color (lambda (self args) (set self 'color (car args)))))
              (obj-methods pt)))))

```
