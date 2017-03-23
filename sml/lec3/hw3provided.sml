(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let
	val r = g f1 f2
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)


val only_capitals = List.filter (fn x => Char.isUpper(String.sub(x,0)))

val longest_string1 = List.foldl (
	fn (a,b) => if String.size a > String.size b then a else b
    ) ""


val longest_string2 = List.foldl (
	fn (a,b) => if String.size a >= String.size b then a else b
    ) ""

fun longest_string_helper f  = List.foldl(
 	fn (a,b) => if f(String.size a, String.size b) then a else b
    ) ""

val longest_string3 = longest_string_helper (fn(x,y)=>x>y)

val longest_string4 = longest_string_helper (fn(x,y)=>x>=y)

val longest_capitalized = longest_string3 o only_capitals

val rev_string = implode o List.rev o explode

fun first_answer t l =
  case l of
      [] => raise NoAnswer
    | x::xs => case t(x) of	  
	          SOME b => b
		| NONE =>  first_answer t xs 
      
  
fun all_answers t l =
  let fun helper(l,acc) =
    case l of
      [] => SOME acc
    | x::xs => case t(x) of	  
	          SOME b => helper(xs, b @ acc)
		| NONE =>  NONE
  in
      helper(l,[])
  end
      


val count_wildcards =1
			 
