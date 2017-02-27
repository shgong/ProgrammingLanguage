(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)


fun filter(s:string, xs: string list):bool*(string list) =
	case xs of
	    [] => (false, [])
	  | x::xs' =>
	    case filter(s, xs') of
		(y, ls) => if same_string(x,s)
			   then (true, ls)
			   else (y, x::ls)		  
	     
fun all_except_option(s:string, xs: string list) =
      case filter(s, xs) of
	  (y, res) => if y then SOME res else NONE
						  
fun get_substitutions1(sub: string list list, s:string): string list =
  case sub of
      [] => []
     |ls::rest =>
      case all_except_option(s, ls) of
	  SOME r => r @ get_substitutions1(rest,s)
       |  NONE => get_substitutions1(rest,s)
     
(* Tail Recursion *)			     
fun get_substitutions2(sub: string list list, s:string): string list =
  let fun solve(sub: string list list, acc: string list) =
	case sub of
	    [] => acc
	  | ls::rest =>
	     case all_except_option(s, ls) of
		 SOME r => solve(rest , acc @ r)	 
	      |  NONE => solve(rest, acc)
  in
      solve(sub, [])
  end


type name = {first:string, middle:string, last:string}
		
fun similar_names(sub: string list list, full:name):name list =
  case full of {first=a, middle=b, last=c} =>
	       helper(
		   a::get_substitutions2(sub,a),
		   b::get_substitutions2(sub,b),
		   c::get_substitutions2(sub,c)
	       )
	       
     
					 
		 
					  
      
  







	     
(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
