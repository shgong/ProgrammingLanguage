

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
	       let fun similar_first (nil) = nil
		     | similar_first (H::T) =
		       {first=H, middle=b, last=c}::similar_first(T)
	       in
		   similar_first(a::get_substitutions2(sub,a))
	       end
		   
    
					 
		 
					  
      
  







	     
(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
fun card_color((suit,_)) =
  case suit of
      Clubs => Black
    | Spades => Black
    | _ => Red 

fun card_value((_,rank)) =
  case rank of
      Ace => 11
   |  Num(i) => i
   |  _ => 10
	       

fun remove_card(cs:card list, c:card, e) =
  let fun contains([]) = raise e
	| contains(H::T)  = if H=c then T else H::contains(T)
  in
      contains(cs)
  end
      
  
fun all_same_color(card1::card2::T) =
  if card_color(card1)=card_color(card2)
  then all_same_color(card2::T)
  else false
  | all_same_color (_:card list) = true
			     
fun sum_cards(cs:card list) =
  let fun sum([], v) = v
	| sum(H::T, v) = sum(T, v + card_value(H)) 
  in
      sum(cs,0)
  end
      
fun score(cs: card list, goal:int) =
  let val v = sum_cards(cs) - goal
      val x = if v>=0 then 3*v else 0 - v
  in
      if all_same_color(cs) then x div 2 else x
  end
      
 
	  
fun officiate(cs:card list, ms:move list, goal:int) =
  let fun turn(held, [], _) = held
	| turn(held, Discard(c)::moves, cards) =
	  turn(remove_card(held,c,IllegalMove), moves,cards)
	| turn(held, Draw::moves, []) = held
	| turn(held, Draw::moves, topdeck::cards) =
	  if sum_cards(held)<goal then
	      turn(topdeck::held, moves, cards)
	  else held 
  in
      score(turn([],ms,cs), goal)
  end
      
      
 
